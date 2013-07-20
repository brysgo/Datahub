require 'spec_helper'
include RequestHelpers

describe "Project" do
  describe "new project" do
    before do
      Project.create!(title: "Another project")
    end
    it "has another project's as a dependency" do
      create_logged_in_user

      visit new_project_path

      fill_in "Title", with: "My project"
      select "Another project", from: "Dependency ids"

      click_on "Save"
      click_on "Edit"

      page.should have_select("Dependency ids", selected: "Another project")
    end
  end

  describe "runtime" do
    let!(:dep1) { Project.create!(title: "Example Dep 1") }
    let!(:dep2) { Project.create!(title: "Example Dep 2") }
    let!(:example_project) do
      Project.create!(
        title: "Example Project",
        dependencies: [dep1, dep2],
        logic_code: """
          (dep, data, acc={}) ->
            acc[dep] = data
            if (x for x of acc).length == 2
              @emit(acc)
            else
              return acc
        """,
        display_code: """
          <script src='http://code.jquery.com/jquery-2.0.3.min.js'></script>
          <script>
            $(document).ready( function() {
              $('.data-box').html(JSON.stringify(datahub));
            })
          </script>
          <div class='data-box'>
            No content found!!
          </div>
        """
      )
    end
    let(:expected_results) { { "#{dep1.id}" => 'hello', "#{dep2.id}" => 'world' } }

    it "runs the logic code every time a dependency is fulfilled" do
      dep2.should_receive(:dependents).and_return([example_project])
      example_project.should_receive(:emit).with(expected_results).and_call_original
      dep1.emit('hello')
      dep2.emit('world')
    end

    describe "an error in the project code" do
      it "prevents the code from being run again" do
        dep1.should_receive(:dependents).and_return([example_project])
        dep2.should_receive(:dependents).and_return([example_project])

        # Throw our exception
        example_project.logic_code = "throw 'Not cool execption!'"
        example_project.save!
        dep1.emit('hello')

        # Try sending new data to our project
        example_project.reload
        example_project.logic_code = " (dep, data, acc={}) -> @emit('yo dawg')"
        example_project.should_not_receive(:emit)
        dep2.emit('world')
      end

      it "resets the failure when the logic code changes" do
        dep1.should_receive(:dependents).and_return([example_project])
        dep2.should_receive(:dependents).and_return([example_project])

        # Throw our exception
        example_project.logic_code = "throw 'Not cool execption!'"
        example_project.save!
        dep1.emit('hello')

        # Change our code
        create_logged_in_user
        visit edit_project_path(example_project)
        fill_in "Logic code", with: "(dep, data, acc={}) -> @emit('yo dawg')"
        click_on "Save"

        # See that it gets run
        example_project.should_receive(:emit)
        dep2.emit('world')
      end
    end

    describe "show page", js:true do
      it "renders the display code on the page" do
        example_project.saved_state = { this: "is", the: "saved", state: "!" }
        example_project.save!
        visit project_result_path(example_project)
        page.should have_content(example_project.saved_state.to_json)
        page.should_not have_content('<div>')
        page.evaluate_script("datahub").should_not be_nil
      end
    end
  end

end

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

    describe "show page", js:true do
      it "renders the display code on the page" do
        example_project.saved_state = { this: "is", the: "saved", state: "!" }
        example_project.save!
        visit project_path(example_project)
        page.should have_content(example_project.saved_state.to_json)
        page.should_not have_content('<div>')
        page.evaluate_script("datahub").should_not be_nil
      end
    end
  end

  def create_logged_in_user
    user = User.create!(
      email: 'user@example.com',
      password: 'password'
    )
    login(user)
    user
  end

  def login(user)
    login_as user, scope: :user
  end
end

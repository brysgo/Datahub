require 'spec_helper'
include RequestHelpers

describe "Twitter API" do
  before do
    Twitter.instance.save!
  end

  it "allows the user to add twitter as a dependency" do
    create_logged_in_user

    visit new_project_path

    fill_in "Title", with: "My project"
    select "Twitter", from: "Dependency ids"

    click_on "Save"

    Twitter.instance.dependents.count.should == 1
  end

  describe "dependent projects" do
    let!(:example_project) do
      Project.create!(
        title: "Example Project",
        dependencies: [Twitter.instance],
        logic_code: """
          (dep, data, acc={}) ->
            return data
        """,
        display_code: """
          <script>
            $(document).ready( function() {
              $('.data-box').html(JSON.stringify(datahub.state));
            })
          </script>
          <div class='data-box'>
            No content found!!
          </div>
        """
      )
    end

    it "calls them when new tweets come in", js:true do
      visit project_path(example_project)
      page.should have_content('null')
      Twitter.instance.incoming(Twitter.instance.id, "Strawberry Fields Forever")
      visit project_path(example_project)
      page.should have_content('Strawberry Fields')
    end
  end
end

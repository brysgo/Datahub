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
  it "calls dependent projects when new tweets come in"
end

require 'spec_helper'

describe "projects/show" do
  before(:each) do
    @project = assign(:project, stub_model(Project,
      :title => "Title",
      :logic_code => "MyText",
      :display_code => "<i>hello html!</i>",
      :saved_state => {hello:'world'}
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/MyText/)
    rendered.should match(/<i>hello html!<\/i>/)
  end

  it "bootstraps javascript datahub object" do
    render
    rendered.should match(/datahub =/)
    rendered.should match(/state: {.*hello.*world.*}/)
  end
end

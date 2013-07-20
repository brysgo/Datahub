require 'spec_helper'

describe "projects/result" do
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
    rendered.should match(/<i>hello html!<\/i>/)
  end

  it "bootstraps javascript datahub object" do
    render
    rendered.should match(/datahub =/)
    rendered.should match(/state: {.*hello.*world.*}/)
  end
end

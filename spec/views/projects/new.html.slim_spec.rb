require 'spec_helper'

describe "projects/new" do
  before(:each) do
    assign(:project, stub_model(Project,
      :title => "MyString",
      :logic_code => "MyText",
      :display_code => "MyText"
    ).as_new_record)
  end

  it "renders new project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", projects_path, "post" do
      assert_select "input#project_title[name=?]", "project[title]"
      assert_select "textarea#project_logic_code[name=?]", "project[logic_code]"
      assert_select "textarea#project_display_code[name=?]", "project[display_code]"
    end
  end
end

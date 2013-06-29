require 'spec_helper'

describe "Project" do
  describe "new project" do
    before do
      Project.create!(title: "Twitter")
    end
    it "has another project's as a dependency" do
      create_logged_in_user

      visit new_project_path

      fill_in "Title", with: "My project"
      select "Twitter", from: "Dependency ids"

      click_on "Save"
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
        """
      )
    end
    it "runs the code every time a dependency is fulfilled" do
      dep2.should_receive(:dependents).and_return([example_project])
      expected_results = { "#{dep1.id}" => 'hello', "#{dep2.id}" => 'world' }
      example_project.should_receive(:emit).with(expected_results).and_call_original
      dep1.emit('hello')
      dep2.emit('world')
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

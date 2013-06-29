require 'spec_helper'

describe Project do

  let!(:dependency1) { Project.create }
  let!(:dependency2) { Project.create }
  let!(:project) { Project.create title: "i am a project", dependencies: [dependency1, dependency2] }
  let!(:dependent1) { Project.create dependencies: [project] }
  let!(:dependent2) { Project.create dependencies: [project] }

  it "has and belongs to many projects as dependencies" do
    expect(project.dependencies.count) == 2
    expect(dependent1.dependencies.count) == 1
    expect(dependent2.dependencies.count) == 1
    expect(dependency1.dependencies.count) == 0
    expect(dependency2.dependencies.count) == 0
  end

  describe "#emit" do
    it "fires the project's event with what it receives" do
      param_list = []
      Project.any_instance.stub(:incoming) do |dep, data|
        param_list << [dep, data]
      end
      project.emit("blarg")
      param_list.length.should == 2
    end
  end

end

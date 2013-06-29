require 'spec_helper'

describe Dependency do

  it "should not except self dependencies" do
    Dependency.new(dependency_id: 3, dependent_id: 3).should_not be_valid
  end

  it "should except dependencies on other projects" do
    Dependency.new(dependency_id: 3, dependent_id: 4).should be_valid
  end

end

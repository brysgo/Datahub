class Dependency < ActiveRecord::Base
  belongs_to :dependency, class_name: 'Project'
  belongs_to :dependent, class_name: 'Project'
end


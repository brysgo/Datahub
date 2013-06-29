class Dependency < ActiveRecord::Base
  validate :not_self_dependent
  belongs_to :dependency, class_name: 'Project'
  belongs_to :dependent, class_name: 'Project'

  private

  def not_self_dependent
    errors[:base] << 'Your project can not depend on itself.' if self.dependency_id == self.dependent_id
  end
end


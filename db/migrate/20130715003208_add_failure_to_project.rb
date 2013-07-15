class AddFailureToProject < ActiveRecord::Migration
  def change
    add_column :projects, :failure, :text
  end
end

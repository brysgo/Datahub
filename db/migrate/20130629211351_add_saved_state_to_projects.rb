class AddSavedStateToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :saved_state, :string
  end
end

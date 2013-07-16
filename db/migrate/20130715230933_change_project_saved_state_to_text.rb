class ChangeProjectSavedStateToText < ActiveRecord::Migration
  def up
    change_column :projects, :saved_state, :text
  end
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

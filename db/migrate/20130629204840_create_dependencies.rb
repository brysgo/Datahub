class CreateDependencies < ActiveRecord::Migration
  def change
    create_table :dependencies do |t|
      t.integer "dependent_id"
      t.integer "dependency_id"
    end

    add_index :dependencies, [:dependency_id, :dependent_id], :unique => true
    add_index :dependencies, [:dependent_id, :dependency_id], :unique => true
  end
end

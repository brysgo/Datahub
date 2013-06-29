class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title
      t.text :logic_code
      t.text :display_code

      t.timestamps
    end
  end
end

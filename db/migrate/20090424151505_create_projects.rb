class CreateProjects < ActiveRecord::Migration
  
  def self.up
    create_table :projects do |table|
      table.string :title
      table.integer :category
      table.string :short_description
      table.text :description
      table.boolean :is_open
      table.timestamps
    end
  end
  
  def self.down
    drop_table :projects
  end
  
end

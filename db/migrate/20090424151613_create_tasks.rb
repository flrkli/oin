class CreateTasks < ActiveRecord::Migration
  
  def self.up
    create_table :tasks do |table|
      table.integer :object_id
      table.string :object_type
      table.integer :user_id
      table.string :title
      table.text :description
      table.datetime :begins_at
      table.datetime :ends_at
      table.boolean :is_private
      table.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
  
end

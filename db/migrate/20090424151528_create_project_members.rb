class CreateProjectMembers < ActiveRecord::Migration
  
  def self.up
    create_table :project_members do |table|
      table.integer :project_id
      table.integer :user_id
      table.boolean :is_admin, :default => false
      table.boolean :is_authorized, :default => false
      table.timestamps
    end
  end

  def self.down
    drop_table :project_members
  end
  
end

class CreateBulletinBoardMessages < ActiveRecord::Migration
  
  def self.up
    create_table :bulletin_board_messages do |table|
      table.integer :project_id
      table.integer :user_id
      table.string :title
      table.text :message
      table.timestamps
    end
  end

  def self.down
    drop_table :bulletin_board_messages
  end
  
end

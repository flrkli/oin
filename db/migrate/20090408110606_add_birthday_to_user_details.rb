class AddBirthdayToUserDetails < ActiveRecord::Migration
  def self.up
    add_column :user_details, :birthday, :date
  end

  def self.down
    remove_column :user_details, :birthday
  end
end

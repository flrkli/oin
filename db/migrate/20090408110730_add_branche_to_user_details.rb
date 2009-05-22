class AddBrancheToUserDetails < ActiveRecord::Migration
  def self.up
    add_column :user_details, :branche, :string
  end

  def self.down
    remove_column :user_details, :branche
  end
end

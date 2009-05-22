class RemoveHeightFromUploads < ActiveRecord::Migration
  def self.up
    remove_column :uploads, :height
  end

  def self.down
    add_column :uploads, :height, :integer
  end
end

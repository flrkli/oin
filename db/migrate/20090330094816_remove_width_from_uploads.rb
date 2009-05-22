class RemoveWidthFromUploads < ActiveRecord::Migration
  def self.up
    remove_column :uploads, :width
  end

  def self.down
    add_column :uploads, :width, :integer
  end
end

class AddIdeaIdToUploads < ActiveRecord::Migration
  def self.up
    add_column :uploads, :idea_id, :integer
  end

  def self.down
    remove_column :uploads, :idea_id
  end
end

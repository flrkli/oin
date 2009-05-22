class AddInnovationIdToUploads < ActiveRecord::Migration
  def self.up
    add_column :uploads, :innovation_id, :integer
  end

  def self.down
    remove_column :uploads, :innovation_id
  end
end

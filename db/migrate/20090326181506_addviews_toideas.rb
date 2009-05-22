class AddviewsToideas < ActiveRecord::Migration
  def self.up
		add_column :ideas, :views, :integer
  end

  def self.down
  end
end

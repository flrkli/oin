class AddCategoryToIdea < ActiveRecord::Migration
  def self.up
		add_column :ideas, :category_id, :integer
		
  end

  def self.down
  end
end

class CreateIdeaComments < ActiveRecord::Migration
  def self.up
    create_table :idea_comments do |t|

			t.text :comment
			t.integer :rating
			t.integer :user_id
			t.integer :idea_id

      t.timestamps
    end
  end

  def self.down
    drop_table :idea_comments
  end
end

class CreateInnovations < ActiveRecord::Migration
  def self.up
    create_table :innovations do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.integer :category_id
      t.string :innovation_type
      t.integer :views

      t.timestamps
    end
  end

  def self.down
    drop_table :innovations
  end
end

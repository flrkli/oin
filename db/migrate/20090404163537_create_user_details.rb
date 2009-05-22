class CreateUserDetails < ActiveRecord::Migration
  def self.up
    create_table :user_details do |t|
      t.string :gender
      t.string :title
      t.string :first_name
      t.string :last_name
      t.string :profession
      t.integer :expert_in_category_id
      t.text :expert_description
      t.string :street
      t.integer :house_number
      t.string :city
      t.integer :postal_code
      t.string :country
      t.integer :phone_number
      t.integer :mobile_phone_number
      t.integer :user_id
      t.integer :level

      t.timestamps
    end
  end

  def self.down
    drop_table :user_details
  end
end

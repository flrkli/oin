# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090521171104) do

  create_table "bulletin_board_messages", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.string   "title"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "category"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "conversations", :force => true do |t|
    t.string   "subject",    :default => ""
    t.datetime "created_at",                 :null => false
  end

  create_table "idea_comments", :force => true do |t|
    t.text     "comment"
    t.integer  "rating"
    t.integer  "user_id"
    t.integer  "idea_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ideas", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.integer  "views"
  end

  create_table "innovations", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "category_id"
    t.string   "innovation_type"
    t.integer  "views"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mail", :force => true do |t|
    t.integer  "user_id",                                          :null => false
    t.integer  "message_id",                                       :null => false
    t.integer  "conversation_id"
    t.boolean  "read",                          :default => false
    t.boolean  "trashed",                       :default => false
    t.string   "mailbox",         :limit => 25
    t.datetime "created_at",                                       :null => false
  end

  create_table "messages", :force => true do |t|
    t.text     "body"
    t.string   "subject",         :default => ""
    t.text     "headers"
    t.integer  "sender_id",                          :null => false
    t.integer  "conversation_id"
    t.boolean  "sent",            :default => false
    t.datetime "created_at",                         :null => false
  end

  create_table "messages_recipients", :id => false, :force => true do |t|
    t.integer "message_id",   :null => false
    t.integer "recipient_id", :null => false
  end

  create_table "project_members", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.boolean  "is_admin",      :default => false
    t.boolean  "is_authorized", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.integer  "category"
    t.string   "short_description"
    t.text     "description"
    t.boolean  "is_open"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "tasks", :force => true do |t|
    t.integer  "object_id"
    t.string   "object_type"
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.datetime "begins_at"
    t.datetime "ends_at"
    t.boolean  "is_private"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tests", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "uploads", :force => true do |t|
    t.integer  "parent_id"
    t.string   "content_type"
    t.string   "filename"
    t.string   "thumbnail"
    t.integer  "size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "idea_id"
    t.integer  "innovation_id"
    t.integer  "project_id"
  end

  create_table "user_details", :force => true do |t|
    t.string   "gender"
    t.string   "title"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "profession"
    t.integer  "expert_in_category_id"
    t.text     "expert_description"
    t.string   "street"
    t.integer  "house_number"
    t.string   "city"
    t.integer  "postal_code"
    t.string   "country"
    t.integer  "phone_number"
    t.integer  "mobile_phone_number"
    t.integer  "user_id"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "birthday"
    t.string   "branche"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code"
    t.datetime "activated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
  end

end

class Project < ActiveRecord::Base
  
  has_many :users, :through => :project_members
  has_many :bulletin_board_messages
  has_many :tasks, :as => :object
  has_many :project_members

	belongs_to :user
  
  validates_presence_of :title
  validates_presence_of :short_description
  validates_presence_of :description
  
end

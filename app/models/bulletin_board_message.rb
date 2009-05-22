class BulletinBoardMessage < ActiveRecord::Base
  
  belongs_to :project
  belongs_to :user
  
  validates_presence_of :title
  validates_presence_of :message
  
end

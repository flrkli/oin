class UserDetail < ActiveRecord::Base

	belongs_to :user

  validates_presence_of :gender, :first_name, :last_name, :country, :profession, :branche, :expert_in_category_id
	validates_acceptance_of :agbs, :message => "Bitte die AGBs akzeptieren"

end

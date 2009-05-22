class Idea < ActiveRecord::Base
	
	belongs_to :user
	belongs_to :category
	has_many :idea_comments, :dependent => :destroy
	has_many :uploads

	validates_presence_of :title, :message => "Bitte Titel eingeben"
	validates_presence_of :description, :message => "Bitte eine Beschreibung eingeben"
	validates_presence_of :user_id, :message => "Bitte Anmelden"
	validates_presence_of :category_id, :message => "Kategorie bitte angeben"

	# returns the rating of an idea

	def get_rating
		@ratings = self.idea_comments
		@count = 0
	
		@ratings.each do |r|
			@count = @count + r.rating
		end

		if @ratings.count != 0
			@average_rating = @count / @ratings.count
		else
			@average_rating = 0
		end

	end

	# this method returns ideas which are filtered
	# order: by which field should the results be ordered (in case order = "rating" then the ideas will be sorted by their rating
	# direction: ASC or DESC
	# condition: whatever condition (e.g. {category_id => "1"} )
	# offset: from which position up, will the results be shown
	# limit: limit of the results the function returns

	def get_ideas(order, direction, condition, offset, limit)

		if order != "rating"
			@ideas = Idea.find(:all, :order => order+" "+direction, :conditions => condition, :limit => limit, :offset => offset)
		else
			@ideas = Idea.find(:all, :conditions => condition)
			@ideas = @ideas.sort_by {|i| [i.get_rating]}.reverse
			
		  # @ideas.slice(offset..(offset+limit-1))

		end
	end
		
end

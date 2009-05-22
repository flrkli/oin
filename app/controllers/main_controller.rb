class MainController < ApplicationController
	

	def index
		@path = [link_to_main]
    @subnavigation = []
  end

end

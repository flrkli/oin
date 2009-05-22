class IdeasController < ApplicationController

	# toDO:  line 82


	uses_tiny_mce
  
	before_filter :login_required, :except =>[:index, :show, :show_all]
	before_filter :idea_admin_required, :only =>[:edit, :upload, :update, :destroy]


	# shows the indexpage of ideas -> index.html.erb
	# params[:category] has the id of the category which the user wanted. 
	# if no category is choosen, params[:category] = nil

  def index

		@path = [link_to_ideas]
		@subnavigation = [link_to_new_idea, link_to_show_all_ideas("Alle Ideen", "title", "ASC", "", 0, 30)]

		@categories = Category.all
		@ideas = Idea.new

		
		# with condition, that only the choosen category is shown

		if params[:category] != nil

			# last added ideas
			@ideas_last = Ideas.new("created_at", "DESC", {:category_id => params[:category]}, 0, 5).ideas 

			# most viewed ideas
			@ideas_viewed = Ideas.new("views", "DESC", {:category_id => params[:category]}, 0, 5).ideas 

			# most rated ideas
			@ideas_rated = Ideas.new("rating", "", {:category_id => params[:category]}, 0, 5).ideas 			


		
		# all ideas are shown

		else
			# last added ideas
			@ideas_last = Ideas.new("created_at", "DESC", "", 0, 5).ideas 

			# most viewed ideas
			@ideas_viewed = Ideas.new("views", "DESC", "", 0, 5).ideas

			# most rated ideas
			@ideas_rated = Ideas.new("rating", "DESC", "", 0, 5).ideas

		end


    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ideas }
    end
  end

	# shows all ideas of a certain type and category
	# here is the way how to do it:
	# link_to("Your Linkname", {:action => "show_all", :title => "Heading", :order => "views", :direction => "DESC", :condition => "{category_id => 1}", :offset => 0, :limit => 30, :page => 10}

	# for more info: application controller 

	def show_all

		@categories = Category.all

		@idea = Idea.new

		@order = params[:order]
		@direction = params[:direction]
		@category = params[:category]

		if params[:page] != nil	
			@page = params[:page]
		else
			@page = 1
		end

		if @category == nil
			@ideas = Idea.paginate :all, :page => @page, :order => @order+" "+@direction 
		else
			@ideas = Idea.paginate_by_category_id @category, :page => @page, :order => @order+" "+@direction 
		end

		
		# title and navigation

		@title = params[:title]
		@path = [link_to_ideas, active_link_to_show_all_ideas(@title, @order, @direction, @condition, @offset, @limit)]

		@subnavigation = [active_link_to_show_all_ideas(@title, @order, @direction, @condition, @offset, @limit), link_to_new_idea]

	end


  # shows a certain idea in detail
	# @idea_comments : all comments to @idea
	# @idea_comment : new comment object, which will be used if someone wants to write a comment
	# @rating : gets the rating of the @idea
	# @uploads : all uploads which were made by the idea creator

  def show
    @idea = Idea.find(params[:id])
		@category = Category.find_by_id(@idea.category_id)

		@path = [link_to_ideas, link_to_idea(@idea)]
		@subnavigation = []
		
		if (current_user != nil && current_user.id == @idea.user_id) || admin_authorized?
			@subnavigation = [link_to_edit_idea(@idea), link_to_destroy_idea(@idea), link_to_idea_uploads(@idea)]
		end 

		@idea_comments = @idea.idea_comments

		@idea_comment = IdeaComment.new
		@idea_comment.idea_id = @idea.id

		@rating = @idea.get_rating

		@uploads = @idea.uploads

		# reset view
		
		@idea.views = @idea.views+1
		@idea.save

		# allows user to delete files
		@delete = false

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @idea }
    end
  end

  
	# page to create a new idea -> new.html.erb

  def new
		@path = [link_to_ideas, link_to_new_idea]
		@subnavigation = [active_link_to_new_idea,link_to_show_all_ideas("Alle Ideen", "title", "ASC", "", 0, 30)]

    @idea = Idea.new
		@categories = Category.find(:all)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @idea }
    end
  end

  # page to edit a idea, only for user who created the idea

  def edit
    @idea = Idea.find(params[:id])
		@categories = Category.find(:all)

		@path = [link_to_ideas, link_to_edit_idea(@idea)]
		@subnavigation = [active_link_to_edit_idea(@idea), link_to_destroy_idea(@idea)]

  end


	# a new idea will be created and the user_id is also saved by connecting the user and idea 		# class
	
	# after the creation of a new idea, the user can upload files for the idea

  def create

		@path = [link_to_ideas, link_to_new_idea]
		@subnavigation = [active_link_to_new_idea,link_to_show_all_ideas("Alle Ideen", "title", "ASC", "", 0, 30)]

    @idea = Idea.new(params[:idea])
		@categories = Category.find(:all)

	
		#connection between the user and idea table/class
		current_user.ideas << @idea

    respond_to do |format|
      if @idea.save
        flash[:notice] = 'Idee wurde erfolgreich gespeichert.'
        redirect_to idea_uploads_path(@idea.id)
      else
				flash[:notice] = 'Ein Fehler ist aufgetreten'
        format.html { render :action => "new" }
        format.xml  { render :xml => @idea.errors, :status => :unprocessable_entity }
      end
    end
  end

	# this is the method which links to the upload form after the creation of a new idea

	def upload

		@uploads = Idea.find(params[:id]).uploads
		@idea = params[:id]
		@idea_obj = Idea.find(@idea)

		# allows user to delete files
		@delete = true

		@path = [link_to_ideas, link_to_idea_uploads(@idea_obj)]
		@subnavigation = [active_link_to_idea_uploads(@idea_obj), link_to_idea(@idea_obj), link_to_show_all_ideas("Alle Ideen", "title", "ASC", "", 0, 30)]
	end


  # updates an idea, but checks first, if the user who created the idea is the same as the  current_user

  def update
    @idea = Idea.find(params[:id])

		
		respond_to do |format|
      if @idea.update_attributes(params[:idea])
        flash[:notice] = 'Idea was successfully updated.'
        format.html { redirect_to(@idea) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @idea.errors, :status => :unprocessable_entity }
      end
    end

  end

	# destroys an idea, but user must be the same as the creator

  def destroy
    @idea = Idea.find(params[:id])
    	@idea.destroy
    	respond_to do |format|
      	format.html { redirect_to(ideas_url) }
      	format.xml  { head :ok }
			end
  end


	

	# before 

	def idea_admin_required
 	 if !(Idea.find_by_id(params[:id]).user_id == current_user.id || admin_authorized?)
			flash[:notice] = 'Sie haben für diese Seite keine Rechte.'
			redirect_to(ideas_path)
		end
end

	
end

class InnovationsController < ApplicationController

	uses_tiny_mce

	before_filter :login_required, :except =>[:index, :show, :show_all]
	before_filter :innovation_admin_required, :only =>[:edit, :update, :destroy]

  def index
    @innovations = Innovation.all

		@latest_innos = Innovation.find :all, :order => "created_at DESC", :limit => 5

		@path = [link_to_innovations]
		@subnavigation = [link_to_new_innovation, link_to_show_all_innovations("Alle Innovationen")]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @innovations }
    end
  end




  def show
    @innovation = Innovation.find(params[:id])



		# reset view
		@innovation.views = @innovation.views+1
		@innovation.save

		@uploads = @innovation.uploads



		@path = [link_to_innovations, link_to_innovation(@innovation)]
		@subnavigation = []
		
		if (current_user != nil && current_user.id == @innovation.user_id) || admin_authorized?
			@subnavigation = [link_to_edit_innovation(@innovation), link_to_destroy_innovation(@innovation), link_to_innovation_uploads(@innovation)]
		end 


    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @innovation }
    end
  end


	def show_all

		@categories = Category.all

		@title = params[:title]
		@order = params[:order]
		@direction = params[:direction]
		@category = params[:category]
		@user_id = params[:user_id]
		@inno = params[:inno]
		
		
		if params[:page] != nil	
			@page = params[:page]
		else
			@page = 1
		end

		if @category == nil

			if @inno == nil
				@innovations = Innovation.paginate :all, :page => @page, :order => @order+" "+@direction
			else
				@innovations = Innovation.paginate_by_innovation_type @inno, :page => @page, :order => @order+" "+@direction
			end
		else
			@innovations = Innovation.paginate_by_category_id @category, :page => @page, :order => @order+' '+@direction
		end

		if @user_id != nil 
			@innovations = Innovation.paginate_by_user_id @user_id, :page => @page, :order => @order+' '+@direction
		end


		@path = [link_to_innovations, link_to_show_all_innovations(@title)]
		@subnavigation = [link_to_new_innovation, active_link_to_show_all_innovations(@title)]

	
	end




  def new
    @innovation = Innovation.new

		@categories = Category.find(:all)


		@path = [link_to_innovations, link_to_new_innovation]
		@subnavigation = [active_link_to_new_innovation]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @innovation }
    end
  end





  def edit
    @innovation = Innovation.find(params[:id])

		@categories = Category.find(:all)

		@path = [link_to_innovations]
		@subnavigation = [link_to_new_innovation]
  end





  def create

		@path = [link_to_innovations]
		@subnavigation = [link_to_new_innovation]

    @innovation = Innovation.new(params[:innovation])

		@innovation.user_id = current_user.id

    respond_to do |format|
      if @innovation.save
        flash[:notice] = 'Innovation was successfully created.'
        format.html { redirect_to(@innovation) }
        format.xml  { render :xml => @innovation, :status => :created, :location => @innovation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @innovation.errors, :status => :unprocessable_entity }
      end
    end
  end





  def update
    @innovation = Innovation.find(params[:id])

    respond_to do |format|
      if @innovation.update_attributes(params[:innovation])
        flash[:notice] = 'Innovation was successfully updated.'
        format.html { redirect_to(@innovation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @innovation.errors, :status => :unprocessable_entity }
      end
    end
  end





  def destroy
    @innovation = Innovation.find(params[:id])
    @innovation.destroy

    respond_to do |format|
      format.html { redirect_to(innovations_url) }
      format.xml  { head :ok }
    end
  end

	
	# only the user who created the innovation or the admin can use methods which are filtered by this function
		
	def innovation_admin_required
 	 if !(Innovation.find_by_id(params[:id]).user_id == current_user.id || admin_authorized?)
			flash[:notice] = 'Sie haben für diese Seite keine Rechte.'
			redirect_to(innovations_path)
		end
end
end

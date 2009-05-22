class IdeaCommentsController < ApplicationController

	# toDO: 	only the user who created the comment or the admin can edit and destroy it 	

	before_filter :login_required


  # there is no html index file

  def index
    redirect_to(ideas_path)
  end

  # shows all comments to a certain idea

  def show
    @idea_comment = IdeaComment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @idea_comment }
    end
  end

  # GET /idea_comments/new
  # GET /idea_comments/new.xml
  def new
    @idea_comment = IdeaComment.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @idea_comment }
    end
  end

  # GET /idea_comments/1/edit
  def edit
    @idea_comment = IdeaComment.find(params[:id])
  end

  # POST /idea_comments
  # POST /idea_comments.xml

	# saves a new comment and goes back to idea 
		
  def create
    @idea_comment = IdeaComment.new(params[:idea_comment])

		current_user.idea_comments << @idea_comment

    respond_to do |format|
      if @idea_comment.save
        flash[:notice] = 'Kommentar erfolgreich hinzugefügt.'
        format.html { redirect_to(:back) }
        format.xml  { render :xml => @idea_comment, :status => :created, :location => @idea_comment }
      else
				flash[:notice] = 'Kommentar konnte nicht eingetragen werden.'
        format.html { redirect_to(:back) }
        format.xml  { render :xml => @idea_comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /idea_comments/1
  # PUT /idea_comments/1.xml
  def update
    @idea_comment = IdeaComment.find(params[:id])

    respond_to do |format|
      if @idea_comment.update_attributes(params[:idea_comment])
        flash[:notice] = 'IdeaComment was successfully updated.'
        format.html { redirect_to(@idea_comment) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @idea_comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /idea_comments/1
  # DELETE /idea_comments/1.xml
  def destroy
    @idea_comment = IdeaComment.find(params[:id])
    @idea_comment.destroy

    respond_to do |format|
      format.html { redirect_to(idea_comments_url) }
      format.xml  { head :ok }
    end
  end
end

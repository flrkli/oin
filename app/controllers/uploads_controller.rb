class UploadsController < ApplicationController
	
	# toDO : only 3 uploads possible 

	def new
		
		if params[:idea_id] != nil
			@uploads = Upload.find_all_by_idea_id(params[:idea_id])
			@type = "idea"
			@type_id = params[:idea_id]
			@form_type = :idea
			@idea = Idea.find(params[:idea_id])
			
			@path = [link_to_ideas, link_to_idea(@idea), link_to_idea_uploads(@idea), link_to_new_idea_upload(@idea)]
			@subnavigation = [active_link_to_new_idea_upload(@idea)]

			else if params[:project_id] != nil
				@uploads = Upload.find_all_by_project_id(params[:project_id])
				@type = "project"
				@type_id = params[:project_id]
				@form_type = :project
				@project = Project.find(params[:project_id])

				@path = [link_to_projects]
				@subnavigation = []

			else
				@uploads = Upload.find_all_by_innovation_id(params[:innovation_id])
				@type = "innovation"
				@type_id = params[:innovation_id]
				@form_type = :innovation
				@innovation = Innovation.find(params[:innovation_id])

				@path = [link_to_innovations, link_to_innovation(@innovation), link_to_innovation_uploads(@innovation), link_to_new_innovation_upload(@innovation)]
				@subnavigation = [active_link_to_new_innovation_upload(@innovation)]
			end
		end

		if check_user(@type, @type_id) == false
			flash[:notice] = "Keine Rechte zum Upload"		
			redirect_to root_path
		end

		@delete = true

  	@upload = Upload.new
	
	end




	def create
		# only 5 uploads are possible for one idea
		@restriction = 5

  	@upload = Upload.new(params[:upload])
		

		if params[:idea_id] != nil
			@type = Idea.find_by_id(params[:idea_id])
			else if params[:project_id] != nil
				@type = Project.find_by_id(params[:project_id])
			else
				@type = Innovation.find_by_id(params[:innovation_id])
			end
		end
		
		
		if (@type.uploads.size < @restriction)
			if @upload.save
				@type.uploads << @upload
   		  flash[:notice] = 'Upload erfolgreich durchgeführt'
   		  redirect_to(:back)
  		else
				flash[:notice] = 'Fehler beim Upload. Eventuell hat ihre Datei das falsche Format'
  	 	  redirect_to(:back)
 			end
		else
			flash[:notice] = 'Upload konnte nicht durchgeführt werden; zu viele Uploads für eine Idee durchgeführt(Max:'+@restriction.to_s+')'
			redirect_to(:back)
		end
	end




	def index
		
		if params[:idea_id] != nil
			@uploads = Upload.find_all_by_idea_id(params[:idea_id])
			@idea = Idea.find(params[:idea_id])

			@path = [link_to_ideas, link_to_idea(@idea), link_to_idea_uploads(@idea)]
			@subnavigation = [link_to_new_idea_upload(@idea)]

			else if params[:project_id] != nil
				@uploads = Upload.find_all_by_project_id(params[:project_id])

			else
				@uploads = Upload.find_all_by_innovation_id(params[:innovation_id])
				@innovation = Innovation.find(params[:innovation_id])

				@path = [link_to_innovations, link_to_innovation(@innovation), link_to_innovation_uploads(@innovation)]
				@subnavigation = [link_to_new_innovation_upload(@innovation)]
			end
		end

		@delete = true


	end





	def destroy

		@path = [link_to_ideas]

		@subnavigation = []

		@upload = Upload.find_by_id(params[:id])
		@upload.destroy
		redirect_to(:back)
	end



	# checks if the user has the right to upload data for a certain idea, project, innovation
	# returns true or false


	def check_user(type, type_id)
	
		if admin_authorized?
			return true
		end
		
		case type 
			when "idea"
				@user_id = Idea.find_by_id(type_id).user_id
			when "project"
				@user_id = Project.find_by_id(type_id).user_id
			when "innovation"
				@user_id = Innovation.find_by_id(type_id).user_id
			else
				return false
		end

		
		if @user_id == current_user.id
			return true
		else
			return false
		end
		
	end


end

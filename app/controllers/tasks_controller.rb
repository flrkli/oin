class TasksController < ApplicationController
  
  before_filter :login_required
  before_filter :restricted_project_authorization_required
  before_filter :task_admin_required, :except => [:index, :new, :create]
  
  
  
  
  def task_admin_required
    @task = Task.find(params[:id])
    if @task.user != current_user
      flash[:notice] = "Sie haben nicht die erforderlichen Rechte, um diese Seite aufzurufen."
      redirect_back_or_default("/")
    end
  end
  
  
  
  
  def create_subnavigation
    if @project = Project.find_by_id(params[:project_id])
      params[:action] == "index" ? links = [active_link_to_workspace_project_tasks(@project)] : links = [link_to_workspace_project_tasks(@project)]
      params[:action] == "new" ? links += [active_link_to_new_workspace_project_task(@project)] : links += [link_to_new_workspace_project_task(@project)]
      if params[:action] == "show" || params[:action] == "edit"
        @task = Task.find params[:id]
        params[:action] == "edit" ? links += [active_link_to_edit_workspace_project_task(@project, @task)] : links += [link_to_edit_workspace_project_task(@project, @task)]
        links += [link_to_destroy_workspace_project_task(@project, @task)]
      end
    else
      params[:action] == "index" ? links = [active_link_to_workspace_tasks] : links = [link_to_workspace_tasks]
      params[:action] == "new" ? links += [active_link_to_new_workspace_task] : links += [link_to_new_workspace_task]
      if params[:action] == "show" || params[:action] == "edit"
        @task = Task.find params[:id]
        params[:action] == "edit" ? links += [active_link_to_edit_workspace_task(@task)] : links += [link_to_edit_workspace_task(@task)]
        links += [link_to_destroy_workspace_task(@task)]
      end
    end
    create_workspace_subnavigation(links)
  end
  
  def create_path
    @project = Project.find_by_id params[:project_id]
    @path = [link_to_workspace]
    if @project
      @path += [link_to_workspace_project(@project), link_to_workspace_project_tasks(@project)]
    else
      @path += [link_to_workspace_tasks]
    end
    case params[:action]
    when "new"
      @path += [link_to_new_workspace_task]
    when "edit"
      @path += [link_to_edit_workspace_task(params[:id])]
    end
  end
  
  
  
  
  def index
    @project = Project.find_by_id(params[:project_id])
    if @project
      @tasks = @project.tasks.find(:all, :conditions => ["(is_private = true AND user_id = user_id) OR is_private = false", user_id = current_user.id], :order => "begins_at")
      @private_tasks = @project.tasks.find_all_by_user_id_and_is_private(current_user, true)
      @public_tasks = @project.tasks.find_all_by_is_private(false)
    else
      @tasks = current_user.tasks
    end
    respond_to do |format|
      format.html
      format.xml {render :xml => @tasks}
    end
  end
  
  def new
    @project = Project.find_by_id(params[:project_id])
    @task = Task.new
    if @project
      @target_url = [:workspace, @project, @task]
    else
      @target_url = [:workspace, @task]
    end
    respond_to do |format|
      format.html
      format.xml {render :xml => @task}
    end
  end
  
  def edit
    @project = Project.find_by_id(params[:project_id])
    @task = Task.find(params[:id])
    if @project
      @target_url = workspace_project_task_path(@project, @task)
    else
      @target_url = workspace_task_path(@task)
    end
  end
  
  def create
    @project = Project.find_by_id(params[:project_id])
    @task = Task.new(params[:task])
    if @project
      @task.object_type = "project"
      @task.object_id = @project.id
      @target_url = workspace_project_tasks_path(@project)
    else
      @task.object_type = "user"
      @task.object_id = current_user.id
      @target_url = workspace_tasks_path
    end
    @task.user_id = current_user.id
    respond_to do |format|
      if @task.save
        flash[:notice] = 'Aufgabe erfolgreich erstellt.'
        format.html {redirect_to @target_url}
        format.xml {render :xml => @task, :status => :created, :location => @task}
      else
        format.html {render :action => "new"}
        format.xml {render :xml => @task.errors, :status => :unprocessable_entity}
      end
    end
  end
  
  def update
    @project = Project.find_by_id(params[:project_id])
    @task = Task.find(params[:id])
    if @project
      @target_url = workspace_project_tasks_path(@project)
    else
      @target_url = workspace_tasks_path
    end
    respond_to do |format|
      if @task.update_attributes(params[:task])
        flash[:notice] = 'Aufgabe erfolgreich aktualisiert.'
        format.html {redirect_to @target_url}
        format.xml {head :ok}
      else
        format.html {render :action => "edit"}
        format.xml {render :xml => @task.errors, :status => :unprocessable_entity}
      end
    end
  end
  
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    respond_to do |format|
      format.html {redirect_to tasks_path}
      format.xml {head :ok}
    end
  end
  
  def update_task
    respond_to do |format|
      format.js
    end
  end
  
end

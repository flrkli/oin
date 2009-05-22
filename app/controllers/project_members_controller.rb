class ProjectMembersController < ApplicationController
  
  before_filter :login_required
  before_filter :restricted_project_authorization_required, :except => [:create]
  
  
  
  
  def create_subnavigation
    create_workspace_subnavigation
  end
  
  def create_path
    @path = [link_to_workspace]
    case params[:action]
      when "index"
        @path += [link_to_workspace_project_members]
      when "authorize"
        @path += [link_to_authorize_workspace_project_members]
    end
  end
  
  
  
  
  def index    
    @authorized_projects = []
    current_user.project_members.find_all_by_is_authorized(true).each do |project_member|
      @authorized_projects += [project_member.project]
    end
    if @project
      @project_members = @project.project_members.find_all_by_is_authorized(true)
    else
      @project_members = {}
      @authorized_projects.each do |project|
        project.project_members.find_all_by_is_authorized(true).each do |project_member|
          if project_member.user != current_user
            @project_members[project_member.user] ||= []
            @project_members[project_member.user] += [project_member]
          end
        end
      end
    end
    respond_to do |format|
      format.html
      format.xml {head :ok}
    end
  end
  
  def authorize
    @authorized_projects = []
    current_user.project_members.find_all_by_is_authorized(true).each do |project_member|
      @authorized_projects += [project_member.project]
    end
    @personal_authorization_requests = current_user.project_members.find_all_by_is_authorized(false)
    if @project
      @authorization_requests = @project.project_members.find_all_by_is_authorized(false)
    else
      @authorization_requests = []
    end
    respond_to do |format|
      format.html
      format.xml {head :ok}
    end
  end
  
  def create
    @project_member = ProjectMember.new(:project_id => params[:project_id], :user_id => current_user.id, :is_authorized => @project.is_open, :is_admin => false)
    respond_to do |format|
      if @project_member.save
        if @project.is_open
          flash[:notice] = "Sie sind dem Projekt erfolgreich beigetreten."
        else
          flash[:notice] = "Sie sind dem Projekt erfolgreich beigetreten. Ihre Authorisierungsanfrage wird an den Projektleiter weitergeleitet."
        end
        format.html {redirect_to(project_path(@project))}
        format.xml {render :xml => @project_member, :status => :created, :location => @project_member}
      else
        flash[:notice] = "Beitritt fehlgeschlagen."
        format.html {redirect_to_(project_path(@project))}
        format.xml {render :xml => @project_member.errors, :status => :unprocessable_entity}
      end
    end
  end
  
  def update
    @project_member = ProjectMember.find(params[:id])
    @project_member.is_authorized = true
    respond_to do |format|
      if @project_member.save
        flash[:notice] = "Authorisierung erfolgreich."
        format.html {redirect_to workspace_project_members_path}
        format.xml {head :ok}
      else
        flash[:notice] = "Authorisierung fehlgeschlagen."
        format.html {redirect_to workspace_project_members_path}
        format.xml {render :xml => @project_member.errors, :status => :unprocessable_entity}
      end
    end
  end
  
  def update_project_members
    respond_to do |format|
      format.js
    end
  end
    
end

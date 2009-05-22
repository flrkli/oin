class WorkspaceController < ApplicationController
  
  before_filter :login_required
  before_filter :project_member_required, :except => :index
  
  
  
  
  def create_subnavigation
    create_workspace_subnavigation
  end
  
  def create_path
    @path = [link_to_workspace]
  end
  
  
  
  
  def index
    respond_to do |format|
      format.html
      format.xml {head :ok}
    end
  end
  
  def show
    respond_to do |format|
      format.html
      format.xml {head :ok}
    end
  end
  
end

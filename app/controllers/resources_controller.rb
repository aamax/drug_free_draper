class ResourcesController < ApplicationController
  before_filter :admin_user,  :only => [:new, :create, :destroy, :edit]

  def new
    @title = "Create New Resource"
    @newresource = Resource.new
  end
  
  def edit
    @title = "Edit Resource"    
    @resource = Resource.find(params[:id])
  end

  def index
    @title = "Drug Free Draper Resource Listing"
    @resources = Resource.all
  end

  def update
    @resource = Resource.find(params[:id])
    
    # update model entry with validation
    if @resource.update_attributes(params[:resource])
      flash[:success] = "Resource updated."
      
      redirect_to list_resources_path
    else
      flash[:failure] = "ERROR: Resource NOT updated."
      @title = "Edit Resource"
      render :action => "edit"
    end 
  end
  
  def create
    @newresource = Resource.new(params[:resource])
    
    if @newresource.save
      flash[:success] = "Resource Saved!"
      redirect_to list_resources_path 
    else
      flash[:failure] = "ERROR: Resource NOT created."
      @title = "Create New Resource"
      render 'new'
    end
  end
  
  def destroy
    Resource.find(params[:id]).destroy
    flash[:success] = "This Resource was destroyed."
    redirect_to list_resources_path
  end

  private
  def admin_user
    redirect_to(root_path) if current_user.nil? || !current_user.admin?
  end

end

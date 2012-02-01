class MembersController < ApplicationController
  before_filter :admin_user,  :only => [:destroy, :index, :edit, :show]

  def new    
    @title = "Create New Member"
    @newmember = Member.new
  end

  def edit
    @title = "Edit Member Data"
    @member = Member.find(params[:id])
  end

  def index
    @title = "Member List"
    @members = Member.all
  end

  def update
    @member = Member.find(params[:id])
    
    # update model entry with validation
    if @member.update_attributes(params[:member])
      flash[:success] = "Member updated."
      
      redirect_to root_path 
    else
      flash[:failure] = "ERROR: Member NOT updated."
      @title = "Edit Member Data"
      render :action => "edit"
    end        
  end
  
  def create
    @newmember = Member.new(params[:member])
    if @newmember.save
      flash[:success] = "Welcome to the Host site!"
      redirect_to list_members_path 
    else
      @title = "Create New Member"
      render 'new'
    end
  end
  
  def destroy
    Member.find(params[:id]).destroy
    flash[:success] = "This Member was destroyed."
    redirect_to list_members_path
  end

  private
  def admin_user
    if current_user.nil?    
      redirect_to(root_path) 
    else
      redirect_to(root_path) unless current_user.admin?
    end
  end
end

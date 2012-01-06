class UsersController < ApplicationController
  before_filter :authenticate, :except => [:new, :create]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,  :only => [:new, :create, :destroy]
  before_filter :not_if_current_user, :only => :destroy

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page], :per_page => 80)
  end

  def new
    @title = "Sign Up"
    @newuser = User.new
  end
  
  def edit
    @title = "Edit user"
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  def update
    @user = User.find(params[:id])
    
    # if current user or admin then
    if (@user == current_user) || current_user.admin?
      # clear out password if blank
      if (params[:user][:password] == "")
        params[:user].delete("password")
        params[:user].delete("password_confirmation")
      end
        
      # update model entry with validation
      if @user.update_attributes(params[:user])
        flash[:success] = "Profile updated."
        
        redirect_to @user 
      else
        flash[:failure] = "ERROR: Profile NOT updated."
        @title = "Edit user"
        render :action => "edit"
      end        
    else
      # show not be updated and redirect to home page
      flash[:failure] = "Profile NOT updated.  You must be the user or an administrator."
      redirect to home_path
    end
  end
  
  def create
    @newuser = User.new(params[:user])
    if @newuser.save
      #sign_in @user
      flash[:success] = "Welcome to the Host site!"
      redirect_to users_path 
      # redirect_to current_user        
    else
      @title = "Sign up"
      render 'new'
    end
  end
  
  def destroy
    flash[:success] = "This User was destroyed."
    redirect_to users_path
  end

  private 
    def correct_user
      @user = User.find(params[:id])      
      redirect_to(root_path) unless current_user?(@user) || current_user.admin?
    end
  
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
      
    def not_if_current_user 
      @user = User.find(params[:id])  
      if @user == current_user
        flash[:failure] = "You may not delete yourself..."
        redirect_to(root_path)
      end
    end
    
end

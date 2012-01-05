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
    if @user == current_user
      if @user.update_attributes(params[:user])
        flash[:success] = "Profile updated."
        
        current_user.update_user_by_current_user(@user)
        
        redirect_to @user
      else
        flash[:failure] = "ERROR: Profile NOT updated."
        @title = "Edit user"
        render :action => "edit"
      end
    else  
      if current_user.admin?
        if @user.update_attribute( :name, params[:user][:name])
          if @user.update_attribute( :email, params[:user][:email] )          
            if @user.update_attribute( :admin, params[:user][:admin] )
              if @user.update_attribute( :teamleader, params[:user][:teamleader] )
                if @user.update_attribute( :street, params[:user][:street] )
                  if @user.update_attribute( :city, params[:user][:city] )
                    if @user.update_attribute( :state, params[:user][:state] )
                      if @user.update_attribute( :zip, params[:user][:zip] )
                        if @user.update_attribute( :login, params[:user][:login] )
                          if @user.update_attribute( :startdate, params[:user][:startdate] )
                            if @user.update_attribute( :fname, params[:user][:fname] )
                              if @user.update_attribute( :lname, params[:user][:lname] )
                                flash[:success] = "Profile updated."
                                
                                current_user.update_user_by_current_user(@user)
                                
                                redirect_to @user
                              else
                                flash[:failure] = "ERROR: Profile NOT updated."
                                @title = "Edit user"
                                render :action => "edit"
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end              
            end
          end
        else
          flash[:failure] = "ERROR: Profile NOT updated."
          @title = "Edit user"
          render :action => "edit"        
        end      
      else
        flash[:failure] = "ERROR: Profile NOT updated."
        @title = "Edit user"
        render :action => "edit"
      end 
    end
  end
  
  def create
    @newuser = User.new(params[:user])
    if @newuser.save
      current_user.create_new_user_by_current_user(@newuser)

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
    current_user.destroy_user_by_current_user(User.find(params[:id]))

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

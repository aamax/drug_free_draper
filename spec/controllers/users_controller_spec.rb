require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'index'" do

    describe "for non-signed-in users" do
      it "should deny access" do
        get :index
        
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end
    
    describe "for signed-in " do
      before(:each) do
        @user = test_sign_in(Factory(:user, :name => "zzzzzz"))
        second = Factory( :user, :name => "Bob", 
                          :email => "another@example.com", 
                          :startdate => "2010",
                          :fname => "Bob",
                          :lname => "Smith")
        third  = Factory( :user, :name => "Ben", 
                          :email => "another@example.net", 
                          :startdate => "2010",
                          :fname => "Ben",
                          :lname => "Jones")

        @users = [second, third]
        60.times do
          @avalue = Factory.next(:email)
          @users << Factory(:user,  :email => @avalue, 
                                    :startdate => "2010",
                                    :name => @avalue,
                                    :fname => "dummy",
                                    :lname => "jackson")
        end
      end
      
      describe " admin users" do
        before(:each) do
          @adminuser = Factory(:user, :email => "admin@example.com", 
                                :admin => true, :startdate => "2010",
                                :fname => "Admin", :lname => "user")
          test_sign_in(@adminuser)
        end
        
        it "delete link should be present" do
          get :index
          response.should have_selector("a", :content => "delete")
        end
        
        it "edit link should be present" do          
          get :index
          response.should have_selector("a", :content => "edit")
        end

        it "new user link should be present" do
          get :index
          response.should have_selector("a", :content => "New User")
        end

      end

      describe "for NON-admin users" do
        it "delete link should not be present" do
          get :index
          response.should_not have_selector("a", :content => "delete")
        end

        it "new user link should not be present" do
          get :index
          response.should_not have_selector("a", :content => "New User")
        end         
      end

      it "should be successful" do
        get :index
        response.should be_success
      end

      it "should have the right title" do
        get :index
        response.should have_selector("title", :content => "All users")              
      end
      
      it "should have an element for each user" do
        get :index
        @users[0..2].each do |user|
          response.should have_selector("li", :content => user.name)
        end
      end
    end
  end # get 'index'
    
  describe "GET 'show'" do
    before(:each) do    
      @user = Factory(:user)
    end
    
    describe "for non-signed-in users" do
      it "should deny access" do
        get :show, :id => @user
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end
    end

    describe "for signed-in users" do

      before(:each) do
        @user = test_sign_in(@user)
      end
      
      it "should be successful" do
        get :show, :id => @user
        response.should be_success
      end
      
      it "should find the right user" do
        get :show, :id => @user
        assigns(:user).should == @user 
      end
      
      it "should have the right title" do
        get :show, :id => @user
        response.should have_selector("title", :content => @user.name)
      end
      
      it "should include the users name" do
        get :show, :id => @user
        response.should have_selector("h1", :content => @user.name)
      end
      
      it "should have a profile image" do
        get :show, :id => @user
        response.should have_selector("h1>img", :class => "gravatar")
      end    
      
      it "should have an edit link for the shown user" do
        get :show, :id => @user
        response.should have_selector("a", :href => edit_user_path(@user))
      end
    end
  end

  describe "GET 'new'" do
    
    describe "access control" do
      it "should allow access to admin users" do
        @admin = Factory(:user, :email => "admin@example.com", 
                          :admin => true, :startdate => "2010")
        test_sign_in(@admin)        
        get :new
        response.should be_success
      end
      
      it "should not allow access to non-admin users" do
        @nonadmin = Factory(:user, :email => "admin@example.com", :startdate => "2010")
        test_sign_in(@nonadmin)       
        get :new
        response.should_not be_success
      end

      it "should redirect non-admin users" do
        @nonadmin = Factory(:user, :email => "admin@example.com")
        test_sign_in(@nonadmin)       
        get :new
        response.should redirect_to(root_path)
      end
      
      describe "access for admin users" do
        before(:each) do
          @admin = Factory(:user, :email => "admin@example.com",
                           :admin => true, :startdate => "2010")
          test_sign_in(@admin)        
          get :new  
        end

        it "should have the correct title" do
          response.should have_selector('title', :content => "Sign Up")
        end
        
        it "should have a name field" do
          response.should have_selector("input[name='user[name]'][type='text']")
        end

        it "should have a fname field" do
          response.should have_selector("input[name='user[fname]'][type='text']")
        end

        it "should have a lname field" do
          response.should have_selector("input[name='user[lname]'][type='text']")
        end

        it "should have an email field" do
          response.should have_selector("input[name='user[email]'][type='text']")
        end

        it "should have a password field" do
          response.should have_selector("input[name='user[password]'][type='password']")
        end

        it "should have a password confirmation field" do
          response.should have_selector(
                            "input[name='user[password_confirmation]'][type='password']")
        end    
      end
    end
    
  end
  
  describe "GET 'edit'" do
    describe "Normal user editting" do
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end
      
      it "should be successful" do
        get :edit, :id => @user
        response.should be_success
      end
      
      it "should have the right title" do
        get :edit, :id => @user
        response.should have_selector("title", :content => "Edit user")
      end
      
      it "should have a link to change the Gravatar" do
        get :edit, :id => @user
        gravatar_url = "http://gravatar.com/emails"
        response.should have_selector("a",  :href => gravatar_url,
                                            :content => "change")
      end

      it "should have a home phone field" do
        get :edit, :id => @user
        response.should have_selector("input[name='user[homephone]'][type='text']")
      end

      it "should have a cell phone field" do
        get :edit, :id => @user    
        response.should have_selector("input[name='user[cellphone]'][type='text']")
      end

      it "should have a start date field" do
        get :edit, :id => @user
        response.should have_selector("input[name='user[startdate]'][type='text']")
      end

      it "non-admin users should not have an administrator field" do
        get :edit, :id => @user
        response.should_not have_selector("input[name='user[admin]'][type='checkbox']")
      end

      it "non-admin users should not  have a team leader field" do
        get :edit, :id => @user
        response.should_not have_selector("input[name='user[teamleader]']")
      end
    end
     
    describe "admin user editting" do
      before(:each) do
        @user = Factory(:user)
        @admin = Factory(:user, :email => "admin@example.com",
                   :admin => true, :startdate => "2010")
        test_sign_in(@admin)        
      end
      
      it "should have an administrator field" do
        get :edit, :id => @admin
        response.should have_selector("input[name='user[admin]'][type='checkbox']")
      end

      it "should have a team leader field" do
        get :edit, :id => @admin
        response.should have_selector("input[name='user[teamleader]']")
      end

      it "should have an administrator field when editting other user" do
        get :edit, :id => @user
        response.should have_selector("input[name='user[admin]'][type='checkbox']")
      end

      it "should have a team leader field when editting other user" do
        get :edit, :id => @user
        response.should have_selector("input[name='user[teamleader]']")
      end
    end
  end

  describe "POST 'create'" do
    describe "failure" do

      before(:each) do
        @attr = { :name => "", :email => "", :password => "",
                  :password_confirmation => "" }
        @admin = Factory(:user, :email => "admin@example.com", 
                          :admin => true, :startdate => "2010")
        @user = Factory(:user, :email => "nonadmin@example.com", :startdate => "2010")          
      end

      it "should not create a user" do
        test_sign_in(@user)
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end

      it "should redirect to root path" do
        test_sign_in(@user)
        post :create, :user => @attr
        response.should redirect_to(root_path)
      end

    end # failure
        
    describe "success" do
      before(:each) do
        @admin = Factory(:user, :email => "admin@example.com", 
                          :admin => true, :startdate => "2010")
        @attr = { :name => "New User", :email => "user@example.com",
                  :password => "foobar", :password_confirmation => "foobar", 
                  :startdate => "2010", :fname => "New", :lname => "User" }   
        test_sign_in(@admin)    
      end

      it "should create a user" do
        
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end

      it "should redirect to the user index page" do
        post :create, :user => @attr
        response.should redirect_to(users_path)
      end   
      
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /Welcome to the Host site!/i
      end 
      
    end # success
  end # POST
  
  describe "PUT 'update'" do

    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end

    describe "failure" do

      before(:each) do
        @attr = { :email => "", :name => "", :password => "",
                  :password_confirmation => "" }
      end

      it "should render the 'edit' page" do
        put :update, :id => @user, :user => @attr
        response.should render_template('edit')
      end

      it "should have the right title" do
        put :update, :id => @user, :user => @attr
        response.should have_selector("title", :content => "Edit user")
      end
    end

    describe "success" do

      before(:each) do
        @attr = { :name => "New Name", :email => "user@example.org",
                  :password => "barbaz", :password_confirmation => "barbaz",
                  :fname => "testfname", :lname => "testlname",
                  :teamleader => true, :street => "mystreet",
                  :city => "draper", :state => "utah",
                  :zip => "11234", :login => "myname",
                  :startdate => 2011, :admin => true }
      end

      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        @user.reload
        @user.name.should  == @attr[:name]
        @user.email.should == @attr[:email]
        @user.fname.should == @attr[:fname]
        @user.lname.should == @attr[:lname]
        @user.teamleader.should  == @attr[:teamleader]
        @user.street.should  == @attr[:street]
        @user.city.should  == @attr[:city]
        @user.state.should  == @attr[:state]
        @user.zip.should  == @attr[:zip]
        @user.login.should  == @attr[:login]
        @user.startdate.should  == @attr[:startdate]
        @user.admin.should  == @attr[:admin]
        
      end

      it "should redirect to the user show page" do
        put :update, :id => @user, :user => @attr
        response.should redirect_to(user_path(@user))
      end

      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/
      end
    end
  end 
  
  describe "authentication of edit/update pages" do
    before(:each) do
      @user = Factory(:user)
    end

    describe "for non-signed-in users" do
      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
      end

      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end   
    
    describe "for signed in users - current user edit/update" do
      before(:each) do
        test_sign_in(@user)       
      end
      
      it "should be successful for access to edit" do
        get :edit, :id => @user
        response.should be_success
      end
      
      it "should have the right title for edit" do
        get :edit, :id => @user
        response.should have_selector("title", :content => "Edit user")
      end   
      
      it "should redirect to show page" do
        put :update, :id => @user, :user => {}
        response.should render_template(@user)  
      end
    end
    
    describe "for signed-in users - wrong user " do

      before(:each) do
        wrong_user = Factory(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
      end

      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end

      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end

  end

  describe "DELETE 'destroy'" do

    before(:each) do
      @user = Factory(:user)
    end

    describe "as a non-signed-in user" do
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end

    describe "as a non-admin user" do
      it "should protect the page" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
    end

    describe "as an admin user" do
      before(:each) do
        @admin = Factory(:user, :email => "admin@example.com", :admin => true)
        test_sign_in(@admin)
      end
      
      it "should not be able to destroy current user" do
        lambda do
          delete :destroy, :id => @admin
          response.should_not change(User, :count).by(-1)
        end
      end

      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end

      it "should redirect to the users page" do
        delete :destroy, :id => @user
        response.should redirect_to(users_path)
      end
    end
  end
end

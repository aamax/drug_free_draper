require 'spec_helper'

describe "Users" do
	it ": the requests/users_spec.rb tests should all work..."
	
	
	
#	describe "update" do
#		describe "success" do
#			it "should change the admin status" 
#			
#			it "should change the name"
#			
#			it "should change the email address"
#			
#			it "should change the password" #do
#        visit signup_path
#        fill_in "Name",         :with => "Example User"
#        fill_in "Email",        :with => "user@example.com"
#        fill_in "Password",     :with => "foobar"
#        fill_in "Confirmation", :with => "foobar"
#        click_button
#        response.should have_selector("div.flash.success",
#                                      :content => "Welcome")
#        response.should render_template('users/show')
#        
#        visit edit_user_path
#        fill_in "Password", 	:with => "foobar"
#        fill_in "Confirmation", :with => "foobar"
#        check "admin"
#        click_button
#        response.should have_selector("div.flash.success",
#                                      :content => "updated")
#        response.should have_selector("admin", :content => "1")
                                      
        
			#end
			
			
#		end
#	end

#  describe "signup" do

#    describe "failure" do
#			it "add tests for new user creation etc."
#			
##      it "should not make a new user - all blank fields" do
##       	lambda do 
##		      visit signup_path
##		      fill_in "Name",         :with => ""
##		      fill_in "Email",        :with => ""
##		      fill_in "Password",     :with => ""
##		      fill_in "Confirmation", :with => ""
##		      click_button
##		      response.should render_template('users/new')
##		      response.should have_selector("div#error_explanation")
##        end.should_not change(User, :count)
##      end

##      it "should not make a new user - pass not match confirm" do
##        lambda do        
##		      visit signup_path
##		      fill_in "Name",         :with => ""
##		      fill_in "Email",        :with => ""
##		      fill_in "Password",     :with => "xxxxxx"
##		      fill_in "Confirmation", :with => "xxxxxxx"
##		      click_button
##		      response.should render_template('users/new')
##		      response.should have_selector("div#error_explanation")
##        end.should_not change(User, :count)
##      end
#    end
#    
#    describe "success" do    
#			before(:each) do
#				@admin = { :password => "foobar", :email => "aamax@xmission.com" }
#				test_sign_in(@admin)
#			end	
#    
#		  it "should make a new user" do
#	      lambda do
#	        visit signup_path
#	        fill_in "Name",         :with => "Example User"
#	        fill_in "Email",        :with => "user@example.com"
#	        fill_in "Password",     :with => "foobar"
#	        fill_in "Confirmation", :with => "foobar"
#	        fill_in "StartDate",		:with => "2010"
#	        click_button
#	        response.should have_selector("div.flash.success",
#	                                      :content => "Welcome")
#	        response.should render_template('users/show')
#	      end.should change(User, :count).by(1)
#	    end
#		end
#  end
#  
#  describe "sign in/out" do

#    describe "failure" do
#      it "should not sign a user in" do
##        visit signin_path
##        fill_in :email,    :with => ""
##        fill_in :password, :with => ""
##        click_button
#        user = Factory(:user)
#        user.email = ""
#        user.password = ""
#        integration_sign_in(user)
#        response.should have_selector("div.flash.error", :content => "Invalid")
#      end
#    end

#    describe "success" do
#      it "should sign a user in and out" do
#        user = Factory(:user)
#        integration_sign_in(user)
#        controller.should be_signed_in
#        click_link "Sign out"
#        controller.should_not be_signed_in
#      end
#    end
#  end


end

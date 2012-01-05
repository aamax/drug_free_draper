require 'spec_helper'

describe PagesController do
  render_views
  
  before(:each) do
    @base_title = "Basic Site | "  
  end

  describe "GET 'home'" do

    describe "when not signed in" do

      before(:each) do
        get :home
      end

      it "should be successful" do
        response.should be_success
      end

      it "should have the right title" do
        response.should have_selector("title",
                                      :content => "#{@base_title}Home")
      end
    end

    describe "when signed in" do

      before(:each) do
        @user = test_sign_in(Factory(:user))
        other_user = Factory(:user, :email => Factory.next(:email), :startdate => "2010")
        get :home
      end
      
      it "should be successful" do
        response.should be_success
      end

      it "should have the right title" do
        response.should have_selector("title",
                                      :content => "#{@base_title}Home")
      end
      
      it "should have a welcome message" do
        response.should have_selector("a",
                                      :content => "Hello " + @user.fname + "!")
      end
      
      
    end
    
  end

  describe "GET 'about'" do
     it "should be successful" do
        get 'about'
        response.should be_success
     end
    it "should have the right title" do
       get 'about'
      response.should have_selector("title",
                        :content => @base_title + "About")
    end
  end
  
end

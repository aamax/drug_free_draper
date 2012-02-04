class LocaleventsController < ApplicationController
  before_filter :admin_user,  :only => [:new, :create, :destroy, :edit]

  def new
  end

  def edit
  end

  def index
    @title = "Drug Free Draper Events"
    @events = Localevent.all
  end

  def show
  end

end

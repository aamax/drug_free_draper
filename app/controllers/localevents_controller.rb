class LocaleventsController < ApplicationController
  before_filter :admin_user,  :only => [:new, :create, :destroy, :edit]

  def new
    @title = "Create New Event"
    @newevent = Localevent.new
  end
  
  def edit
    @title = "Edit Event"
    @event = Localevent.find(params[:id])
  end

  def show
    @event = Localevent.find(params[:id])
    @title = "Show Event"
  end

  def index
    @title = "Drug Free Draper Events"
    @events = Localevent.all
  end

  def update
    @event = Localevent.find(params[:id])
    
    # update model entry with validation
    if @event.update_attributes(params[:localevent])
      flash[:success] = "Event updated."
      
      redirect_to @event 
    else
      flash[:failure] = "ERROR: Event NOT updated."
      @title = "Edit Event"
      render :action => "edit"
    end 
  end
  
  def create
    @newevent = Localevent.new(params[:localevent])
    
    if @newevent.save
      flash[:success] = "Event Saved!"
      redirect_to list_events_path 
    else
      flash[:failure] = "ERROR: Event NOT created."
      @title = "Create New Event"
      render 'new'
    end
  end
  
  def destroy
    Localevent.find(params[:id]).destroy
    flash[:success] = "This Event was destroyed."
    redirect_to list_events_path
  end

  private
  def admin_user
    redirect_to(root_path) if current_user.nil? || !current_user.admin?
  end

end

class MembersController < ApplicationController
  def new
    @title = "Create New Member"
  end

  def edit
    @title = "Edit Member Data"
  end

  def index
    @title = "Member List"
  end

end

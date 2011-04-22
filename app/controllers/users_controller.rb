class UsersController < ApplicationController
  #http://asciicasts.com/episodes/250-authentication-from-scratch
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url, :notice => "Signup Complete"
    else
      #TODO: display some error?
      render "new"
    end
  end

  def edit
    if logged_in?
      @user = current_user 
    else
      flash.now.alert = "Please log in"
      redirect_to root_url, :notice => "Please log in"
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to profile_path, :notice => "Update Complete"
    else
      redirect_to profile_path, :notice => "Failed to update your profile."

    end
  end
end

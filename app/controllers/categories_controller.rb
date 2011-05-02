class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    @user = current_user
    @category = Category.new(params[:category])
    @user.categories << @category
    #TODO: error handling
    if @user.save
      redirect_to user_path(@user)
    else
      render "new"
    end
  end
end

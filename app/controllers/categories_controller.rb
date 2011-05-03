class CategoriesController < ApplicationController
  #TODO: Fix up respond_with
  #      http://ryandaigle.com/articles/2009/8/6/what-s-new-in-edge-rails-cleaner-restful-controllers-w-respond_with
  #      http://teamco-anthill.blogspot.com/2010/04/rails-http-status-code-to-symbol.html
  
  before_filter :pre_auth?

  respond_to :html, :json

  def new
    @category = Category.new
  end

  def create
    @user = current_user
    @category = Category.new(params[:category])
    @user.categories << @category
    #TODO: error handling
    #TODO: AJAX this
    if @user.save
      redirect_to user_path(@user)
    else
      render "new"
    end
  end

  def show
    @user = current_user
    respond_to do |format|
      if @user.categories.exists?(params[:id])
        @category = @user.categories.find(params[:id])
        format.html
        format.json { render :json => @category }
      else
        format.html { redirect_to user_path(current_user), :notice => "No such category exists" }
        format.json { head :not_found, :status => :not_found }
      end
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    @n = @category.name
    @notice =  "Category '#{@n}' deleted"
    
    respond_to do |format|
      if @category.destroyed?
        format.html { redirect_to user_path(current_user), :notice => @notice }
        format.json { head :ok }
      else
        format.html { redirect_to user_path(current_user), :notice => "Unable to delete this category" }
      end
    end
  end
end

class CategoriesController < ApplicationController
  #TODO: Fix up respond_with
  #      http://ryandaigle.com/articles/2009/8/6/what-s-new-in-edge-rails-cleaner-restful-controllers-w-respond_with
  #      http://teamco-anthill.blogspot.com/2010/04/rails-http-status-code-to-symbol.html
  
  before_filter :pre_auth?

  respond_to :html, :json

  #
  # Views a new Category form
  #
  def new
    @category = Category.new
  end

  #
  # Creates a new Category
  #
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

  #
  # Shows an existing Category
  #
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

  #
  # Deletes a category
  #
  def destroy
    @category = Category.find(params[:id])

    # Make sure we are only deleting a category that
    # belongs to the current user
    if @category.user_id != current_user.id
      respond_to do |format|
        format.html { redirect_to user_path(current_user), :notice => "No Category to Delete" }
        format.json { head :access_denied }
      end
      return
    end

    @category.destroy
    @n = @category.name
    @notice =  "Category '#{@n}' deleted"
    
    respond_to do |format|
      if @category.destroyed?
        format.html { redirect_to user_path(current_user), :notice => @notice }
        format.json { head :ok }
      else
        format.html { redirect_to user_path(current_user), :notice => "Unable to delete this category" }
        format.json { head :bad_request }
      end
    end
  end

end

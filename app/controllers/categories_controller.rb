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

  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    @notice = @category.name + " deleted"
    respond_to do |format|
      if @category.destroyed?
        format.html { redirect_to user_path, :notice => @notice }
        format.json { head :ok }
      else
        format.html { redirect_to user_path, :notice => "Unable to delete this category" }
      end
    end
    
  end
end

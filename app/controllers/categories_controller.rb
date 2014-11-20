class CategoriesController < ApplicationController
  before_action :find_resource, only: [:edit, :update]
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  def category_params
    params.require(:category).permit(:name)
  end
end

class ItemsController < ApplicationController
  before_action :find_resource, only: [:new, :edit, :update]

  def index
    @items      = Item.all
    @categories = Category.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to @item
    else
      render :new
    end
  end

  def update
    @item.update(item_params)
    @item.update_categories(params[:item][:category_ids])
    redirect_to item_path(@item)
  end

  def edit
  end

  private

  def item_params
    params.require(:item).permit(:title, :description, :price, :category_ids, :image)
  end
end

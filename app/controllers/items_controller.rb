class ItemsController < ApplicationController
  def show
    @item = Item.find(params[:id])
  end

  def index
    @items      = Item.all
    @categories = Category.all
  end
end

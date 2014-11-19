class ItemsController < ApplicationController
  def index
    @items = Item.all
    @categories = Category.all
  end

  def show

  end

  def new
  end

  def create
  end

  def edit
  end
end

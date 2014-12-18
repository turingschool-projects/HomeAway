class PropertiesController < ApplicationController
  def show
    @property = Property.find(params[:id])
  end

  def index
    @properties = Property.all
    @categories = Category.all
  end
end

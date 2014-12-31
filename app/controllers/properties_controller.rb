class PropertiesController < ApplicationController
  before_action :set_property, only: [:edit, :update]
  before_action :set_categories, only: [:new, :create, :edit, :update]

  before_action :require_host,  only: [:new]
  before_action :require_owner, only: [:edit]
  def new
    @property = Property.new
    @property.user = current_user
    3.times { @property.photos.build }
  end

  def create
    @property = Property.new(property_params)
    @property.user = current_user

    if @property.save
      redirect_to user_path(current_user)
    else
      render :new
    end
  end

  def show
    @property = Property.find(params[:id])
  end

  def update
    @property.update(property_params)
    if @property.save
      redirect_to user_path(current_user)
    else
      render :edit
    end
  end

  def edit
    3.times { @property.photos.build }
  end

  def index
    @properties = Property.active.includes(:category, :photos)
  end

  private
  def set_property
    @property = Property.find(params[:id])
  end

  def set_categories
    @categories = Category.pluck(:name, :id)
  end

  def property_params
    params.require(:property).permit(:title, :description, :price, :retired, :occupancy, :bathroom_private, :user_id, :category_id, address_attributes: [:id, :line_1, :line_2, :city, :state, :zip, :country], photos_attributes: [:id, :image])
  end

  def require_owner
    unless current_user && @property.user_id == current_user.id
      flash[:notice] = "Unauthorized"
      redirect_to properties_path
    end
  end

  def require_host
    unless current_user && current_user.host?
      flash[:notice] = "Unauthorized"
      redirect_to properties_path
    end
  end
end

class PropertiesController < ApplicationController
  before_action :set_property, only: [:edit, :update]
  before_action :set_categories, only: [:new, :create, :edit, :update]

  before_action :require_host,  only: [:new, :create]
  before_action :require_owner_partner_or_admin, only: [:edit, :update]

  def new
    @property = Property.new
    @property.user = current_user
    3.times { @property.photos.build }
  end

  def create
    @property = Property.new(property_params)
    @property.user = current_user

    if @property.save
      redirect_to property_photos_path(@property)
    else
      render :new
    end
  end

  def show
    @property = Property.find(params[:id])
    @dates = @property.booked_dates
    @fave = current_user.favorites.pluck(:property_id).include?(@property.id) if current_user
  end

  def update
    @property.update(property_params)
    if @property.save
      if current_user_is_owner(@property) || current_user_is_admin
        redirect_to user_path(@property.user)
      else
        redirect_to user_path(current_user)
      end
    else
      render :edit
    end
  end

  def edit
    if @property.photos.empty?
      3.times { @property.photos.build }
    end
  end

  def index
    @properties = Rails.cache.fetch("all_active_properties") do
      Property.active.includes(:category, :photos).search(params[:search], params[:moneySlide], params[:category]).paginate(:page => params[:page], :per_page => 6)
    end

    if request.xhr?
      render partial: "partials/listings"
    end
  end

  private

  def set_property
    @property = Property.find(params[:id])
  end

  def set_categories
    @categories = Category.pluck(:name, :id)
  end

  def property_params
    params.require(:property).permit(:title, :description, :price, :retired, :occupancy, :bathroom_private, :user_id, :category_id, :photo, address_attributes: [:id, :line_1, :line_2, :city, :state, :zip, :country])
  end

  def require_owner_partner_or_admin
    unless current_user_is_admin || current_user_is_owner(@property) || current_user_is_partner(@property)
      flash[:notice] = "Unauthorized"
      redirect_to properties_path
    end
  end

  def current_user_is_owner(property)
    current_user && property.user_id == current_user.id
  end

  def current_user_is_partner(property)
    current_user && property.user.partner_ids.include?(current_user.id)
  end

  def require_host
    unless current_user_is_host
      flash[:notice] = "Unauthorized"
      redirect_to properties_path
    end
  end
end

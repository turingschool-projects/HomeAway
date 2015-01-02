class PhotosController < ApplicationController
  before_action :set_property
  before_action :require_host

  def index
    @photos = @property.photos
  end

  def edit
    @photo = @property.photos.find(params[:id])
  end

  def update
    @photo = @property.photos.find(params[:id])
    @photo.update(photo_params)
    if @photo.save
      redirect_to property_photos_path(@property)
    else
      render :edit
    end
  end

  def new
    @photo = @property.photos.build
  end

  def create
    @photo = @property.photos.build(photo_params)
    if @photo.save
      redirect_to property_photos_path(@property), notice: "Photo was successfully created"
    else
      render :new, notice: "Something went wrong"
    end
  end

  private

  def set_property
    @property = Property.find(params[:property_id])
  end

  def photo_params
    params.require(:photo).permit(:image, :primary)
  end

  def require_host
    unless current_user == @property.user
      redirect_to user_path(current_user), notice: "You may only manage your own property photos."
    end
  end
end

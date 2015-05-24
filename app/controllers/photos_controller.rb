class PhotosController < ApplicationController
  before_action :set_property
  before_action :set_photo, only: [:edit, :update, :destroy]
  before_action :require_host_or_admin_or_partner

  def index
    @photos = @property.photos
  end

  def new
    @photo = @property.photos.build
  end

  def create
    @photo = @property.photos.build(photo_params)
    if @photo.save
      redirect_to property_photos_path(@property), notice: "Photo was successfully created"
    else
      render :new
    end
  end

  def edit
  end

  def update
    @photo.update(photo_params)
    if @photo.save
      redirect_to property_photos_path(@property), notice: "Photo was successfully updated"
    else
      render :edit
    end
  end

  def destroy
    @photo.destroy
    redirect_to property_photos_path(@property)
  end

  private

  def set_property
    @property = Property.find(params[:property_id])
  end

  def set_photo
    @photo = @property.photos.find(params[:id])
  end

  def photo_params
    params.require(:photo).permit(:image_file_name, :primary)
  end

  def require_host_or_admin_or_partner
    unless current_user_is_owner || current_user_is_admin || current_user_is_partner
      redirect_to user_path(current_user), notice: "You must be admin to manage other users' property photos."
    end
  end

  def current_user_is_owner
    current_user == @property.user
  end

  def current_user_is_partner
    @property.user.partners.include? current_user
  end
end

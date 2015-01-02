class PhotosController < ApplicationController
  before_action :set_property

  def new
    @photo = @property.photos.build
  end

  def create
    @photo = @property.photos.build(photo_params)
    if @photo.save
      redirect_to @property, notice: "Photo was successfully created"
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
end

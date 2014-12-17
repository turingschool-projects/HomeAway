class Admin::PropertiesController < Admin::BaseAdminController
  before_action :set_property, only: [:edit, :update]

  def index
    @properties      = Property.all
    @categories = Category.all
  end

  def new
    @property = Property.new
  end

  def create
    @property = Property.new(property_params)
    if @property.save
      redirect_to admin_properties_path
    else
      render :new
    end
  end

  def update
    @property.update(property_params)
    if @property.save
      redirect_to admin_properties_path
    else
      render :edit
    end
  end

  def edit
  end

  private

  def set_property
    @property = Property.find(params[:id])
  end

  def property_params
    params.require(:property).permit(:title, :description, :price, :image, :retired, category_ids: [])
  end

end

class Admin::OrdersController < Admin::BaseAdminController

  def index
    @orders = Order.all
  end

end

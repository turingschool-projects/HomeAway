class Admin::BaseAdminController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :require_admin

  layout 'admin'

  protected

end

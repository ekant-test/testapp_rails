class Admin::BaseController < ApplicationController
  layout 'admin'
  before_filter :auth_user

  def auth_user
    redirect_to root_path unless user_signed_in?
  end
end

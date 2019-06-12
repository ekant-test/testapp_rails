class Admin::SessionsController < ApplicationController
  layout 'admin'
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user.present?
      if user.is_admin?
        user.valid_password?(params[:password])
        sign_in(user)
        if user_signed_in?
          flash[:notice] = "Sign in successfully!"
          redirect_to admin_users_path and return
        else
          flash[:notice] = "Input is invalid!"
          redirect_to admin_root_path and return
        end
      else
        flash[:notice] = "You are not Admin!"
        redirect_to admin_root_path and return
      end
    else
      flash[:notice] = "Input is invalid!"
      redirect_to admin_root_path
    end
  end
end

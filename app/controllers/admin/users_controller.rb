class Admin::UsersController < Admin::BaseController
  before_action :load_user, only: [:destroy, :lock, :unlock]
  def index
    @q = User.ransack(params[:q])
    @users =@q.result.where(is_admin: false).where.not(id: Company.pluck(:owner_id))
  end

  def create
  end

  def my_profile
  end

  def lock
    @user.lock_access!
    flash[:notice] = "Unactive user successfully!"
    redirect_to admin_users_path
  end

  def unlock
    @user.unlock_access!
    flash[:notice] = "Active user successfully!"
    redirect_to admin_users_path
  end

  def destroy
    ActiveRecord::Base.transaction do
      begin
        @user.destroy!
        flash[:notice] = "Destroy user successfully!"
      rescue => e
        flash[:error] = "Destroy user fail!"
        raise ActiveRecord::Rollback
      end
    end
    redirect_to admin_users_path
  end

  def update
    ActiveRecord::Base.transaction do
      if current_user.update(email: params[:email])
        if params[:password].present? && params[:password_confirmation]
          if current_user.reset_password(params[:password], params[:password_confirmation])
            flash[:notice] = "Update account info successfully!"
          end
        else
          flash[:error] = "Update account info fail!"
        end
      else
        flash[:error] = "Update account info fail!"
      end
    end
    redirect_to my_profile_admin_users_path
  end

  private
  def load_user
    @user = User.find(params[:id])
  end
end

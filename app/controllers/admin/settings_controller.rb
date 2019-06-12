class Admin::SettingsController < Admin::BaseController
  before_action :load_setting
  def index
  end

  def update
    if @setting.update(permit_params)
      flash[:notice] = "Updated setting!"
    else
      flash[:error] = "Update setting fail!"
    end
    redirect_to admin_settings_path
  end

  def load_setting
    @setting = Setting.first
  end

  def permit_params
    params.permit(:show_company_text)
  end
end

class V1::RegistersController < V1::BaseController
  api :POST, '/sign_up', "Create an user"
  example '
  {
    "code": 200,
    "message": "Sign up successfully",
    "data": "Let check mail and active your account!"
  }
  '
  error :code => 500, :desc => "Process faild"
  param :email, String, :desc => "email"
  param :password, String, :desc => "password"
  param :name, String, :desc => "name"
  param :sur_name, String, :desc => "surname"
  def create
    render json: error_message("Please checked for terms and conditions!") and return if params["term"].blank? && params["is_web"].present?
    user = User.find_by(email: params['email'])
    user.destroy if user.present?
    if params[:company_name].present?
      company = Company.create!(company_params)
      user = company.users.build(user_params)
    else
      user = User.new(user_params)
    end
    if user.save
      company.update!(owner_id: user.id) if company.present?
      render json: success_message("response_registerSuccess", "Let check mail and active your account!")
    else
      company.destroy if company.present?
      render json: error_message(user.errors.full_messages.collect(&:strip).uniq.first)
    end
  end

  private
    def user_params
      params.permit(:email, :password, :password_confirmation, :language, :name, :middle_name, :sur_name, :gender)
    end

    def company_params
      c_params = params.permit(:email)
      c_params.merge!({name: params[:company_name].to_s})
      c_params.merge!({company_key: 1_000_000 + Random.rand(10_000_000 - 1_000_000)})
    end
end

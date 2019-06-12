class V1::PasswordController < V1::BaseController
  # include DeviseTokenAuth::Concerns::User
  # before_create :skip_confirmation!

  api :POST, '/forgot_password', "Forgot password"
  example '
  {
    "code": 200,
    "message": "forgot password",
    "data": "Please check your email!"
  }
  '
  error :code => 500, :desc => "Process faild"
  param :email, String, :desc => "email", :required => true
  def create
    user = User.find_by(email: params[:email])
    return render json: error_message("forgot email not found") if user.blank?
    sign_out(user)
    reset_password_token = user.set_reset_password_token
    user.send_reset_password_instructions
    yield resource if block_given?
    render json: success_message("response_forgotPassword")
  end

  def update
    original_token = params[:reset_password_token]
    recoverable = User.find_by(reset_password_token: original_token)
    if recoverable.persisted?
      if recoverable.reset_password_period_valid?
        if recoverable.reset_password(params[:password], params[:password_confirmation])
          sign_out(recoverable)
          render json: success_message("reset password successfully!")
        else
          render json: error_message(recoverable.errors.full_messages)
        end
      else
        recoverable.errors.add(:reset_password_token, :expired)
        render json: error_message(recoverable.errors.full_messages)
      end
    end
  end
end

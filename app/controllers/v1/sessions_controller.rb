class V1::SessionsController < V1::BaseController
  before_action :auth_user, only: :destroy

  api :POST, '/sign_in', "Login"
  example '
  {
    "code": 200,
    "message": "Sign in successfully!",
    "data": {
      "id": 2,
      "email": "vovantri92@gmail.com",
      "name": "sadad",
      "middle_name": "",
      "sur_name": "dsedsdsdsds",
      "gender": "Female",
      "native_language": "",
      "language": "English",
      "api_token": "-eAf323-t8T6cY0HXtDm_A",
      "qr_code": "",
      "record_url": ""
    }
  }
  '
  error :code => 500, :desc => "response_loginIncorrect"
  param :email, String, :desc => "email", :required => true
  param :password, String, :desc => "password", :required => true
  def create
    user = User.find_by(email: session_params[:email])
    if user.present?
      render json: error_message("response_loginIncorrect", "") and return unless user.valid_password?(session_params[:password])
    else
      render json: error_message("response_loginIncorrect", "") and return
    end

    if params[:is_web].present? && user.id != user.company.owner_id
      render json: error_message("response_userNotHasRole", "") and return
    end

    if user.locked_at.present? || (params[:is_web].blank? && user.language.blank?)
      render json: error_message("response_accountLocked", "") and return
    end

    if user.confirmed_at.blank?
      render json: error_message("response_emailNotConfirm", "") and return
    end

    sign_in(user)
    if user_signed_in?
      user.send(:generate_token) if user.expire_at.blank? || (user.expire_at.to_i < Time.current.to_i)
      current_record = user.recordings.where("lower(record_type) = 'user'").first
      qr_code = current_record.present? ? current_record.qr_code : ''
      render json: success_message("Sign in successfully!",
        UserSerializer.new(user).serializable_hash)
    else
      render json: error_message("response_loginIncorrect", "") and return
    end
  end

  api :POST, '/sign_in_by_socials', "Login"
  example '
  {
    "code": 200,
    "message": "Sign in successfully!",
    "data": {
      "id": 2,
      "email": "vovantri92@gmail.com",
      "name": "sadad",
      "middle_name": "",
      "sur_name": "dsedsdsdsds",
      "gender": "Female",
      "native_language": "",
      "language": "English",
      "api_token": "-eAf323-t8T6cY0HXtDm_A",
      "qr_code": "",
      "record_url": ""
    }
  }
  '
  error :code => 500, :desc => "Params invalid"
  param :social_token, String, :desc => "social_token", :required => true
  param :social_type, String, :desc => "social_type", :required => true
  def sign_in_by_socials
    render json: error_message("Missing social token", "") and return if params[:social_token].blank?
    render json: error_message("Missing social type", "") and return if params[:social_type].blank?
    social = Social.new(params[:social_token], params[:social_type])
    user_social_info = social.get_user_social_info

    render json: error_message("Social token invalid", "") and return if user_social_info["error"].present? || user_social_info["errorCode"].present?
    user_social_info = resulf_info(user_social_info)
    user = User.find_by(email: user_social_info['email'])
    password = Devise.friendly_token[0,20]
    if user.blank?
      user = User.new(
        name: user_social_info["first_name"],
        sur_name: user_social_info["last_name"],
        email: user_social_info["email"] ? user_social_info["email"] : "#{TEMP_EMAIL_PREFIX}-#{user_social_info["id"]}-#{params[:social_type]}.com",
        password: password,
        confirmed_at: Time.current,
        is_social_user: true
      )
      user.skip_confirmation!
      user.save
    end

    if user.locked_at.present?
      render json: error_message("Account is locked!", "") and return
    end

    sign_in(user)
    if user_signed_in?
      user.send(:generate_token) if user.expire_at.blank? || (user.expire_at.to_i < Time.current.to_i)
      current_record = user.recordings.where("lower(record_type) = 'user'").first
      qr_code = current_record.present? ? current_record.qr_code : ''
      render json: success_message("Sign in successfully!",
        UserSerializer.new(user).serializable_hash)
    else
      render json: error_message("response_loginIncorrect", "") and return
    end
  end

  api :DELETE, '/sign_out', "Logout"
  example '
  {
    "code": 200,
    "message": "Sign out successfully",
    "data": ""
  }
  '
  error :code => 401, :desc => "Unauthorized"
  def destroy
    sign_out(current_user)
    render json: success_message("Sign out successfully",'')
  end

  private
  def session_params
    params.permit(:email, :password)
  end

  def mobile_device?
    request.user_agent =~ /\b(Android|iPhone|iPad|Windows Phone|Opera Mobi|Kindle|BackBerry|PlayBook)\b/i
  end

  def resulf_info(res)
    case params[:social_type]
      when "facebook"
        res
      when "linkedin"
        {"id" => res["id"], "name" => "#{res['firstName']} #{res['lastName']}", "email" => res["emailAddress"], "first_name" => res["firstName"], "last_name" => res["lastName"]}
      when "google"
        {"id" => res["id"], "name" => res["name"], "email" => res["email"], "first_name" => res["given_name"], "last_name" => res["family_name"]}
      end
  end
end

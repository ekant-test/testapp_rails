class V1::UsersController < V1::BaseController
  before_action :auth_user
  before_action :load_user, only: [:unlock]

  api :GET, '/users', "Show current users for company"
  example '
  {
    "code": 200,
    "message": "Show user successfully",
    "data": {
      "users": [
        {
          "id": 2,
          "email": "vovantri92+1@gmail.com",
          "name": "Tri",
          "middle_name": "",
          "sur_name": "Vo Van",
          "gender": "Female",
          "is_social_user": false,
          "native_language": "",
          "language": "English",
          "company_key": ""
        }
      ]
    }
  }
  '
  error :code => 401, :desc => "Unauthorized"
  def index
    company = current_user.company
    users = company.attend_users
    users = users.search(params[:name]) if params[:name].present?
    serializer_users = ActiveModel::ArraySerializer.new(users, each_serializer: CompanyMembersSerializer)
    render json: success_message("Show user successfully", users: serializer_users)
  end

  api :POST, '/users/check_email', "Show current users for company"
  example '
  {
    "code": 200,
    "message": "Check user successfully",
    "data": {
       "is_company_member": false,
       "message": "You are not members of Company"
    }
  }
  '
  def check_email
    is_company_member = current_user.company.present?
    if is_company_member
      render json: success_message("Check user successfully", {is_company_member: is_company_member})
    else
      render json: success_message("Check user successfully", {is_company_member: is_company_member, message: 'You are not members of Company'})
    end
  end

  api :GET, '/users/detail', "Show current user"
  example '
  {
    "code": 200,
    "message": "Show user successfully",
    "data": {
      "id": 13,
      "email": "vovantri92+1@gmail.com",
      "name": "AR",
      "middle_name": "",
      "sur_name": "Tri",
      "gender": "Female",
      "native_language": "",
      "language": "English",
      "api_token": "TzbHNLkcCt6PXjTRO6xX9Q",
      "qr_code": "",
      "record_url": ""
    }
  }'
  error :code => 401, :desc => "Unauthorized"
  def show
    render json: success_message("Show user successfully", UserSerializer.new(current_user).serializable_hash)
  end

  api :GET, '/users/update', "Update current user"
  example '
  {
    "code": 200,
    "message": "Update user successfully",
    "data": {}
  }
  '
  error :code => 401, :desc => "Unauthorized"
  error :code => 500, :desc => "Process faild"
  param :email, String, :desc => "email"
  param :password, String, :desc => "password"
  param :name, String, :desc => "name"
  param :sur_name, String, :desc => "surname"
  def update
    user_attr = current_user.is_social_user ? update_social_user_params : update_user_params
    if current_user.update(user_attr)
      current_user.update!(language: params[:language]) if current_user.language.blank?
      render json: success_message("Update user successfully!",
        UserSerializer.new(current_user).serializable_hash)
    else
      render json: error_message(current_user.errors.full_messages.join(","))
    end
  end

  api :GET, '/v1/users/create_multiple_users', "Update current user"
  example '
  {
    "code": 200,
    "message": "Create user successfully",
    "data": {}
  }
  '
  error :code => 401, :desc => "Unauthorized"
  error :code => 500, :desc => "Process faild"
  def create_multiple_users
    users_attrs = get_user_attrs
    render json: error_message("Data is invalid") and return if users_attrs.blank?
    company = current_user.company
    users_attrs.each do |user_info|
      attrs = { name: user_info['name'],
        surname: user_info['sur_name'],
        email: user_info['email'],
        status: true
      }
      user = User.find_by(email: user_info['email'])
      if user.present?
        user.update(company_key: company.company_key, company_id: company.id)
        company.update!(count_user_use_key: company.count_user_use_key + 1)
      end
      attend_user = company.attend_users.build(attrs)
      attend_user.save!
    end
    render json: success_message("Create users successfully")
  end

  api :GET, '/users/lock', "Lock current user"
  example '
  {
    "code": 200,
    "message": "Locked user successfully",
    "data": {}
  }
  '
  error :code => 401, :desc => "Unauthorized"
  error :code => 500, :desc => "Process faild"
  def lock
    current_user.lock_access!
    render json: success_message("Locked user successfully")
  end

  def unlock
    @user.unlock_access!
    render json: success_message("Unlock user successfully")
  end

  api :DELETE, '/users/destroy', "Lock current user"
  example '
  {
    "code": 200,
    "message": "Destroy user successfully!",
    "data": {}
  }
  '
  error :code => 401, :desc => "Unauthorized"
  error :code => 500, :desc => "Process faild"
  def destroy
    if current_user.is_social_user
      if current_user.destroy
        render json: success_message("Destroy user successfully!") and return
      else
        render json: error_message("Destroy user fail!") and return
      end
    else
      render json: error_message("This user is not social user!") and return
    end
  end

  api :DELETE, '/users/destroy_users', "Lock current user"
  example '
  {
    "code": 200,
    "message": "Destroy user successfully!",
    "data": {}
  }
  '
  error :code => 401, :desc => "Unauthorized"
  error :code => 500, :desc => "Process faild"
  def destroy_users
    user_ids = params[:user_ids].split(",")
    user_ids.each do |user_id|
      user = AttendUser.find user_id
      user.destroy!
    end
    render json: success_message("Destroy user successfully!") and return
  end

  api :PUT, '/users/add_company_key', "add company key"
  example '
  {
    "code": 200,
    "message": "Add company key for user successfully!",
    "data": {}
  }
  '
  error :code => 401, :desc => "Unauthorized"
  error :code => 500, :desc => "Process faild"
  param :company_key, String, :desc => "company_key"
  def add_company_key
    company = Company.find_by(company_key: params[:company_key])
    render json: error_message("response_invalidCompanyKey") and return if company.blank?
    attend_user = company.attend_users.find_by(email: current_user.email, status: false)
    if attend_user.present? && attend_user.update(status: true)
      company.update!(count_user_use_key: company.count_user_use_key + 1)
      render json: success_message("Add company key for user successfully!",
        UserSerializer.new(current_user).serializable_hash) and return
    else
      render json: error_message("response_userNotInCompany") and return
    end
  end

  api :PUT, '/users/remove_company_key', "add company key"
  example '
  {
    "code": 200,
    "message": "Remove company key for user successfully!",
    "data": {}
  }
  '
  error :code => 401, :desc => "Unauthorized"
  error :code => 500, :desc => "Process faild"
  def remove_company_key
    attend_user = AttendUser.find_by(email: current_user.email, status: true)
    render json: error_message("User haven't company key") and return if attend_user.blank?
    company = attend_user.company
    if attend_user.present? && attend_user.update(status: false)
      company.update!(count_user_use_key: company.count_user_use_key - 1) if company.count_user_use_key > 0
      render json: success_message("Remove company key successfully!") and return
    else
      render json: error_message("Remove company key fail") and return
    end
  end

  def destroy_user
    attend_user = AttendUser.find_by(id: params[:user_id])
    if attend_user.destroy
      render json: success_message("Destroy user successfully!") and return
    else
      render json: error_message("Destroy user fail!") and return
    end
  end

  private
    def user_params
      params_user = params.permit(:email, :language, :name, :middle_name, :sur_name, :gender)
      params_user = params_user.merge({password: params[:password], password_confirmation: params[:password]}) if params[:password].present?
      params_user
    end

    def update_user_params
      params_user = params.permit(:name, :middle_name, :sur_name, :gender)
      params_user = params_user.merge({password: params[:password], password_confirmation: params[:password]}) if params[:password].present?
      params_user
    end

    def update_social_user_params
      params_user = params.permit(:language, :name, :middle_name, :sur_name, :gender)
      params_user = params_user.merge({password: params[:password], password_confirmation: params[:password]}) if params[:password].present?
      params_user
    end

    def company_params
      params.permit(:email, :name)
    end

    def load_user
      if params[:id].present?
        @user = User.find_by(id: params[:id])
      elsif params[:user_id]
        @user = User.find_by(id: params[:user_id])
      end
      if @user.blank?
        render json: error_message("User not found!")
      end
    end

    def get_user_attrs
      params_users = []
      params[:users].each do |idx, user_info|
        if user_info['email'].present?
          params_users << user_info
        end
      end
      params_users
    end

    def user_attrs(user_info)
      { name: user_info['name'],
        sur_name: user_info['sur_name'],
        email: user_info['email'],
        password: Devise.friendly_token.first(8)
      }
    end
end

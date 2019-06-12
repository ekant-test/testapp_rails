class UserSerializer < ActiveModel::Serializer
  attributes :id, :company, :email, :name, :middle_name, :sur_name, :gender, :is_social_user, :record,
            :native_language, :language, :api_token, :record_name, :qr_code, :record_url, :company_key, :company_status

  def name
    object.name || ''
  end

  def middle_name
    object.middle_name || ''
  end

  def sur_name
    object.sur_name || ''
  end

  def native_language
    object.native_language || ''
  end

  def record
    @current_record = object.recordings.where("lower(record_type) = 'user'").first
    @current_record.present? ? @current_record : {}
  end

  def qr_code
    qr_code = @current_record.present? ? @current_record.qr_code : ''
  end

  def record_name
    name = @current_record.present? ? @current_record.name : ''
  end

  def record_url
    record_url = @current_record.present? ? @current_record.record_file.url.to_s : ''
  end

  def company
    attend_user = AttendUser.find_by(email: object.email, status: true)
    @company = attend_user.present? ? attend_user.company : nil
  end

  def company_key
    @company.try(:company_key) || ''
  end

  def company_status
    owner_id = @company.try(:owner_id)
    owner = User.find_by(id: owner_id)
    plan = owner.plans.order(updated_at: :desc).first if owner.present?
    (plan.present? && plan.date_expire.present? && plan.date_expire > Date.today) ? true : false
  end
end

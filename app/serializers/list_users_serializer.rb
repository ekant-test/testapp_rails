class ListUsersSerializer < ActiveModel::Serializer
  attributes :id, :company, :email, :name, :middle_name, :sur_name, :gender, :is_social_user,
            :native_language, :language, :company_key, :full_name

  def name
    object.name || ''
  end

  def middle_name
    object.middle_name || ''
  end

  def sur_name
    object.sur_name || ''
  end

  def full_name
    object.full_name || ''
  end

  def native_language
    object.native_language || ''
  end

  def company
    attend_user = AttendUser.find_by(email: object.email)
    @company = attend_user.company
  end

  def company_key
    @company.try(:company_key) || ''
  end
end

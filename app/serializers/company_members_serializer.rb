class CompanyMembersSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :surname, :full_name

  def name
    object.name || ''
  end

  def email
    object.email || ''
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
end

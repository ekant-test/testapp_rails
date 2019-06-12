class SearchResultsSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :native_name, :language, :record_url, :record_type, :qr_code, :reported, :upvoted

  def record_url
    object.record_file.url.to_s
  end

  def reported
    reporte = object.rates.where(user_id: scope[:user_id], rate_type: 'report')
    reporte.present?
  end

  def upvoted
    upvote = object.rates.find_by(user_id: scope[:user_id], rate_type: 'upvote')
    upvote.present?
  end

  def native_name
    object.native_name.to_s
  end

  def qr_code
    object.qr_code.to_s
  end

  def email
    User.find(scope[:user_id]).email if scope[:user_id].present?
  end
end

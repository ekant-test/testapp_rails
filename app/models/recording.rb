class Recording < ActiveRecord::Base
  belongs_to :user
  has_many :rates, dependent: :destroy
  has_attached_file :record_file,
    hash_secret: "@SecretNomen@", # decode with base64
    storage: 's3',
    s3_credentials: { bucket: Settings.s3.bucket, access_key_id: Settings.s3.access_key_id, secret_access_key: Settings.s3.secret_access_key },
    s3_region: 'ap-southeast-1',
    url: ":s3_domain_url",
    path: "/audios/:class/:attachment/:basename-:hash.:extension",
    default_url: ""
  
  validates_attachment_content_type :record_file, content_type: /\Aaudio\/.*\Z/
  # validates_attachment :record_file, :content_type => { :content_type => ["audio/mpeg", "audio/mp3", "audio/m4a", 'application/mp3', 'application/x-mp3'] }
  validates :name, :language, presence: true

  scope :live, -> { where(status: 1) }

  def self.search(name, language, record_type, action = nil)
    sql = ""
    if name.present?
      # attr_name = 'native_name'
      # if !!name.match(/^[a-zA-Z0-9_\-+ ]*$/)
      #   attr_name = 'name'
      # end
      if action == 'autocomplete'
        sql += " (lower(native_name) like '#{name.downcase}%' or lower(name) like '#{name.downcase}%' or (native_name) like '#{name.downcase}%' or (name) like '#{name.downcase}%')"
      else
        sql += " (lower(native_name) = '#{name.downcase}' or lower(name) = '#{name.downcase}' or (native_name) like '#{name.downcase}%' or (name) like '#{name.downcase}%')"
      end
    end

    if language.present? && language != "All Languages"
      sql += sql.present? ? " and lower(language) = '#{language.downcase}' " : " lower(language) = '#{language.downcase}' "
    end
    if record_type.present?
      sql += sql.present? ? " and lower(record_type) = '#{record_type.downcase}' " : " lower(record_type) = '#{record_type.downcase}' "
    end
    sql = 'name = null' if name.nil?
    where(sql).live.order("votes_count desc, record_type asc")
  end
end

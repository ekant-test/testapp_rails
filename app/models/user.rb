require 'csv'
class User < ActiveRecord::Base
  include Stripeable

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :rates, dependent: :destroy
  has_many :recordings, dependent: :destroy
  has_many :plans, dependent: :destroy
  has_one :company, foreign_key: :owner_id
  belongs_to :company, foreign_key: :company_id
  has_many :identities,  dependent: :destroy

  validates :name, :sur_name, presence: true
  validates :password, format: { with: /\A[a-zA-Z0-9-_!@#$%^&*()+.]+\z/, multiline: true, message: 'Password is wrong format'} , :if => lambda{ new_record? || !password.nil? }

  after_destroy :destroy_company
  after_save :disable_recordings

  def destroy_company
    companies = Company.where(owner_id: id)
    companies.destroy_all if companies.present?
  end

  def company_owner
    company = Company.find_by(owner_id: self.id)
  end

  def owner?
    self.id == self.company.try(:owner_id)
  end

  def disable_recordings
    company = company_owner
    user_ids = company.present? ? User.where(company_id: company.id).pluck(:id) : self.id
    if self.locked_at.present?
      Recording.where(user_id: user_ids).update_all(status: 0)
    elsif self.locked_at.blank?
      Recording.where(user_id: user_ids).update_all(status: 1)
    end
  end

  def set_reset_password_token
    raw, enc = Devise.token_generator.generate(self.class, :reset_password_token)
    self.reset_password_token   = enc
    self.reset_password_sent_at = Time.now.utc
    self.save(validate: false)
    raw
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          sur_name: "Empty",
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def full_name
    "#{name} #{sur_name}"
  end

  def self.import(file, company)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      user = company.users.find_by(email: row["email"]) || company.users.new
      attrs = row.to_hash
      attrs["sur_name"] = attrs.delete("surname")
      user.attributes = attrs.slice(*accessible_attributes)
      user.skip_confirmation!
      user.password = Devise.friendly_token.first(8)
      user.save!
    end
  end

  def self.accessible_attributes
    ["name", "sur_name", "email"]
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path,csv_options: {encoding: "iso-8859-1:utf-8"})
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def self.search(name)
    where("lower(name) like '#{name.downcase}%'")
  end

  private
  def time_expire
    (Time.current + 30.days).to_i
  end

  def generate_token
    self.api_token = SecureRandom.urlsafe_base64(nil, false)
    self.expire_at = (Time.current + 3.hours)
    self.save!
  end
end

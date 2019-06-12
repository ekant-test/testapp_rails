class Company < ActiveRecord::Base
  has_many :users, foreign_key: :company_id, dependent: :destroy
  belongs_to :owner, foreign_key: :owner_id
  has_many :attend_users
end

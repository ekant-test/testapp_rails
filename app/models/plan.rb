class Plan < ActiveRecord::Base
  belongs_to :user

  NAME = {
    plan_base: "Nomen Base 10 User Plan",
    plan_single: "Nomen Single User Plan",
    plan_10: 'Nomen 10 User Plan',
    plan_25: 'Nomen 25 User Plan',
    plan_100: 'Nomen 100 User Plan',
    plan_1000: 'Nomen 1000 User Plan',
  }.freeze

  scope :trail, -> { where("date_purchased IS NULL") }
  scope :actived, -> { where("date_purchased IS NOT NULL") }
  scope :oldest_by_expired, -> { order("date_expire DESC") }
end

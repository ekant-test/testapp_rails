class Language < ActiveRecord::Base
  has_many :available_languages
  validates :name, presence: true
  validates_uniqueness_of :name, presence: true

  accepts_nested_attributes_for :available_languages, :allow_destroy => true

  scope :publish, -> { where(status: true) }
end

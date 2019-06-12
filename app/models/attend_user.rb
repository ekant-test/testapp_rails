class AttendUser < ActiveRecord::Base
  belongs_to :company

  def self.search(name)
    where("lower(name) like '#{name.downcase}%'")
  end

  def full_name
    "#{name} #{surname}"
  end
end

class Rate < ActiveRecord::Base
  belongs_to :user
  belongs_to :recording

  validates :rate_type, presence: true
  scope :votes, -> {where(rate_type: 'upvote')}
  scope :reports, -> {where(rate_type: 'report')}
  after_create  :update_rates_count
  after_destroy :destroy_rates_count

  def update_rates_count
    if rate_type == 'upvote'
      Recording.increment_counter(:votes_count, recording_id)
    else
      Recording.increment_counter(:reports_count, recording_id)
    end
  end

  def destroy_rates_count
    if rate_type == 'upvote'
      Recording.decrement_counter(:votes_count, recording_id)
    else
      Recording.decrement_counter(:reports_count, recording_id)
    end
  end
end

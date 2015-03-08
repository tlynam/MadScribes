class Story < ActiveRecord::Base
  belongs_to :user
  has_many :sentences

  validates_presence_of :title, :user
  validates_numericality_of :writing_period, :voting_period, :rounds
  validates_length_of :body, maximum: 10_000


  # Returns an integer if there are still rounds to go, and we're not in a voting period
  def current_round(include_voting_period: true)
    if started_at
      round_duration = writing_period + voting_period
      round = (Time.now - started_at) / round_duration

      return if round > rounds
      return if !include_voting_period && round.modulo(1) > 0.5
      round.round
    end
  end
end

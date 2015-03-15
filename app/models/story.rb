class Story < ActiveRecord::Base
  belongs_to :user
  has_many :sentences

  validates_presence_of :title, :user
  validates_numericality_of :writing_period, :voting_period, :rounds
  validates_length_of :body, maximum: 10_000
  #validate numbers are > 0

  def round
    if started_at && range = find_time_range
      range[1][0]
    end
  end

  def period
    if started_at && range = find_time_range
      range[1][1]
    end
  end

  def active?
    !!(started_at && round)
  end

  def seconds_left_in_period
    if started_at && range = find_time_range
      (range[0].last - Time.now).to_i
    end
  end

  def time_ranges
    if started_at
      round_duration = writing_period + voting_period
      rounds.times.flat_map do |round|
        beginning = started_at + (round_duration * round)

        [
          [beginning                   ..(beginning + writing_period), [round+1, :writing]],
          [(beginning + writing_period)..(beginning + round_duration), [round+1, :voting]]
        ]
      end.to_h
    end
  end

  def find_time_range(time: Time.now)
    time_ranges.find{ |range, _| range.cover? time }
  end

  def percent_story_left
    if started_at == nil
      return 0
    elsif !active?
      return 100
    else
     return ((round.to_f / rounds.to_f) * 100).to_i
    end
  end

  def sentence_submitted?(current_user)
    sentences.where(user: current_user, round: round).present?
  end

  def vote_submitted?(current_user)
    sentences.where(round: round).pluck(:votes).flatten.include?(current_user.id)
  end

  def create_body
    temp_round = active? ? round : (rounds + 1)
    sentences.where("round < ?", temp_round).where(winner: true).order(:round).pluck(:body).to_sentence(words_connector: "  ", two_words_connector: "  ", last_word_connector: "  ")
  end
end

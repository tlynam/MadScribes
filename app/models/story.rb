class Story < ActiveRecord::Base
  belongs_to :user
  has_many :sentences, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  validates_presence_of :title, :user
  validates_numericality_of :writing_period, :voting_period, :rounds, greater_than: 0
  validates_length_of :body, maximum: 10_000

  TIME_PERIODS = [
    ['2 minutes', 2.minutes],
    ['15 seconds', 15.seconds],
    ['30 seconds', 30.seconds],
    ['45 seconds', 45.seconds],
    ['1 minute', 1.minute],
    ['3 minutes', 3.minutes],
    ['5 mintues', 5.minutes],
    ['10 mintues', 10.minutes],
    ['30 minutes', 30.minutes],
    ['1 hour', 1.hour],
    ['6 hours', 6.hours],
    ['12 hours', 12.hours],
    ['24 hours', 24.hours]
  ]

  after_create :subscribe_author

  def subscribe_author
    subscriptions.create user: user
  end

  scope :long_running, ->{ where "(writing_period + voting_period) > ?", 30.minutes }

  def long_running?
    writing_period + voting_period > 30.minutes
  end

  duration_sql = <<-SQL
    extract(epoch from started_at) +
    (writing_period + voting_period)
    * rounds
  SQL

  scope :active,   ->{ where "#{duration_sql} > extract(epoch from now())" }
  scope :finished, ->{ where "#{duration_sql} < extract(epoch from now())" }
  scope :pending,  ->{ where started_at: nil }

  scope :search, -> q { where "to_tsvector(body) @@ to_tsquery(?)", q if q.present? }

  def self.send_emails
    active.long_running.each do |story|
      if (Time.now - story.find_time_range[0].first) < 10.minutes
        story.subscriptions.each do |subscription|
          NotificationMailer.notification_email(story,subscription.user).deliver_now
        end
      end
    end
  end

  def self.populate_body
    finished.where(body: nil).each do |story|
      story.update_attributes! body: story.create_body
    end
  end

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

  def game_over?
    started_at && !round
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

  def winning_sentences
    scope = sentences.where(winner: true)
    scope = scope.where "round < ?", round if round
    scope
  end

  def create_body
    winning_sentences.order(:round).pluck(:body).join(" ")
  end

  def leaderboard
    sentences.includes(:user).group_by(&:user).map do |user, sentences|
      score = sentences.sum{ |s| s.votes.count }
      [score, user]
    end.sort.reverse
  end
end

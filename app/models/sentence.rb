class Sentence < ActiveRecord::Base
  belongs_to :user
  belongs_to :story

  validates_presence_of :user, :body
  validates_numericality_of :round
  validate :sentence_must_be_submitted_in_correct_period
  validates_uniqueness_of :round, scope: [:user_id, :story_id], message:
    "can't add multiple sentences per round"
  before_save :add_period, if: :body_changed?

  before_validation :derive_round, if: :new_record?
  def derive_round
    self.round ||= story.round
  end

  def sentence_must_be_submitted_in_correct_period
    if body_changed? && story.period == :voting
      errors.add(:body, "can't add sentence when it isn't time to write")
    elsif votes_changed? && story.period == :writing
      errors.add(:body, "can't vote a sentence when it isn't time to vote")
    elsif !story.period
      errors.add(:body, "can't add sentence when story isn't active")
    end
  end

  def add_period
    body << '.' unless %w[. ? !].include? body.last
  end

  def update_current_winner
    contenders = story.sentences.where(round: round)
    if contenders.none?{ |s| s.votes.count > votes.count }
      contenders.update_all winner: false
      self.winner = true
    end
  end
end

class Sentence < ActiveRecord::Base
  belongs_to :user
  belongs_to :story

  validates_presence_of :user, :body
  validates_numericality_of :round
  # validate :sentence_must_be_submitted_in_current_writing_period
  # validate :cant_save_multiple_sentences_per_round
  # add period at end of sentence if not present?

  before_validation :derive_round, if: :new_record?
  def derive_round
    self.round = story.round
  end

  def sentence_must_be_submitted_in_current_writing_period
    unless story.round == :writing
      errors.add(:body, "can't add sentence when it isn't time to write")
    end
  end

  def cant_save_multiple_sentences_per_round
    if user.sentences.pluck(:round).include?(derive_round)
      errors.add(:body, "can't add multiple sentences per round")
    end
  end

  def current_winner?
    contenders = story.sentences.where(round: round)
    if contenders.none?{ |s| s.votes.count > votes.count }
      contenders.update_all winner: false
      self.winner = true
    end
  end
end

class Sentence < ActiveRecord::Base
  belongs_to :user
  belongs_to :story

  validates_presence_of :user, :body
  validates_numericality_of :round

  before_validation :derive_round, if: :new_record?
  def derive_round
    self.round = story.current_round(include_voting_period: false)
  end

end

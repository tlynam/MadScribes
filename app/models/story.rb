class Story < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title, :user, :body
  validates_numericality_of :writing_period, :voting_period
  validate_length_of :body, maximum: 10_000

end

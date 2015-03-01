class Story < ActiveRecord::Base
  belongs_to :user
  has_many :sentences

  validates_presence_of :title, :user
  validates_numericality_of :writing_period, :voting_period
  validates_length_of :body, maximum: 10_000

end

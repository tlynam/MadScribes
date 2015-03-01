class Sentence < ActiveRecord::Base
  belongs_to :user
  belongs_to :story

  validates_presence_of :user, :body
  validates_numericality_of :round

end

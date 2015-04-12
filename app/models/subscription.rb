class Subscription < ActiveRecord::Base
  belongs_to :story
  belongs_to :user

  before_create :create_unsubscribe_token

  def create_unsubscribe_token
  	self.unsubscribe_token = SecureRandom.urlsafe_base64 10
  end
end

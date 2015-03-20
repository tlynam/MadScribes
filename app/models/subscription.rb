class Subscription < ActiveRecord::Base
  belongs_to :story
  belongs_to :user

end

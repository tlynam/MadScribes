class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :stories
  has_many :sentences
  has_many :subscriptions

  validates_length_of :username, maximum: 20
  validates :email, uniqueness: true
  validates :username, uniqueness: true, if: :username?

  def score
    sentences.sum 'array_length(votes, 1)'
  end

  def display_name
    username.presence || email
  end
end

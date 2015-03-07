# == Schema Information
#
# Table name: stories
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  title          :string
#  body           :text
#  writing_period :integer          default("45"), not null
#  voting_period  :integer          default("45"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Story < ActiveRecord::Base
  belongs_to :user
  has_many :sentences

  validates_presence_of :title, :user
  validates_numericality_of :writing_period, :voting_period
  validates_length_of :body, maximum: 10_000

end

# == Schema Information
#
# Table name: sentences
#
#  id         :integer          not null, primary key
#  body       :text             not null
#  user_id    :integer          not null
#  story_id   :integer          not null
#  round      :integer          default("1"), not null
#  votes      :integer          default("{}"), not null, is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Sentence < ActiveRecord::Base
  belongs_to :user
  belongs_to :story

  validates_presence_of :user, :body
  validates_numericality_of :round

end

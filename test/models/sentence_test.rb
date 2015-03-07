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

require 'test_helper'

class SentenceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

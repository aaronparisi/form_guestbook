# == Schema Information
#
# Table name: people
#
#  id               :integer          not null, primary key
#  birthday         :date
#  body_temperature :float
#  can_send_email   :boolean
#  country          :string
#  description      :text
#  email            :string
#  extension        :string
#  favorite_time    :time
#  graduation_year  :integer
#  name             :string
#  price            :decimal(, )
#  secret           :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

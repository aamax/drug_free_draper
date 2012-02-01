# == Schema Information
#
# Table name: members
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  service    :boolean
#  events     :boolean
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Member do
  pending "add some examples to (or delete) #{__FILE__}"
end

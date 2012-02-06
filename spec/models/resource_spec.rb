# == Schema Information
#
# Table name: resources
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :string(255)
#  website     :string(255)
#  phone       :string(255)
#  contact     :string(255)
#  category    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Resource do
  pending "add some examples to (or delete) #{__FILE__}"
end

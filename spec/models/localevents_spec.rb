# == Schema Information
#
# Table name: localevents
#
#  id          :integer         not null, primary key
#  when        :datetime
#  location    :string(255)
#  contact     :string(255)
#  name        :string(255)
#  description :string(255)
#  website     :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Localevents do
  pending "add some examples to (or delete) #{__FILE__}"
end

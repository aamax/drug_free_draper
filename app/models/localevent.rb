# == Schema Information
#
# Table name: localevents
#
#  id          :integer         not null, primary key
#  when        :string(255)
#  time        :string(255)
#  location    :string(255)
#  contact     :string(255)
#  name        :string(255)
#  description :string(255)
#  website     :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Localevent < ActiveRecord::Base
  attr_accessible :when, :location, :contact, :name, :description, :website
  
end

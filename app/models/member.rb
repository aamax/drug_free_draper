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
require 'digest'

class Member < ActiveRecord::Base
  attr_accessible :name, :email, :service, :events
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates   :name,  :presence => true,
              :length   => { :maximum => 50 }
                    
  validates   :email, :presence => true,  
            :format => { :with => email_regex },
            :uniqueness => { :case_sensitive => false }
  
  default_scope :order => "name asc" 
  
  
end

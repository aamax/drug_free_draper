Factory.define :user do |user|
  user.name         "Allen Maxwell"
  user.fname        "Allen"
  user.lname        "Maxwell"
  user.email          "aamax@xmission.com"
  user.password       "foobar"
  user.password_confirmation  "foobar"
  user.homephone      "801 790 4500"
  user.cellphone      "801 502 4745"
  user.street         "13013 Shadowlands Lane"
  user.city           "Draper"
  user.state          "Ut"
  user.zip            "84020"
  user.startdate      "2010"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :shifttype do |shifttype|  
  shifttype.shortname     "P1Weekend"
  shifttype.description   "Portico"
  shifttype.starttime     "08:00"
  shifttype.endtime       "4:30"
  shifttype.speedcontrol  "Big Emma 1:00, 2:00, 3:00"
end

Factory.define :shift do |shift|
  shift.shift_date      "12/12/2011"
  shift.user
  shift.shifttype
end




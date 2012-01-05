require 'csv'

namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    restore_users
  end  
  
end

def restore_users
  filename = "../userdata.csv"

  if File.exists?(filename) 
    puts "Loading Users From File #{filename}"

    bpastHeader = false
    
    CSV.foreach(filename) do |row|
      if !bpastHeader
        bpastHeader = true
        next
      end
    
      sPassword = "Password1"
      
      if row[1].blank? || row[3].blank?
        sval = row[0].split(' ')
        row[1] = sval[0]
        row[3] = sval[1]
      end
      
      aHost = User.create!(:name => row[0],
                         :fname => row[1],
                         :midinit => row[2],
                         :lname => row[3],
                         :email => row[4],
                         :login => row[5],
                         :homephone => row[6],
                         :cellphone => row[7],
                         :street => row[8],
                         :city => row[9],
                         :state => row[10],
                         :zip => row[11],
                         :startdate => row[12],                           
                         :password => "#{sPassword}",
                         :password_confirmation => "#{sPassword}") 
      if row[13] == "true"
        aHost.toggle!(:admin)
      end  
      if row[14] == "true"
        aHost.toggle!(:teamleader)
      end                         

      puts "imported user: " + row[0]            
    end # CSV
  else
    fail "User data file not found."
  end # if file exists  
end

def restore_shifttypes
  filename = "../shifttypedata.csv"

  if File.exists?(filename) 
    puts "Loading Shift Types From File #{filename}"

    bpastHeader = false
    
    CSV.foreach(filename) do |row|
      if !bpastHeader
        bpastHeader = true
        next
      end
    
      aShift = Shifttype.create!(:shortname => row[0],
                             :description => row[1],
                             :starttime => row[2],
                             :endtime => row[3],
                             :speedcontrol => row[4])       

      puts "imported shift type: " + row[0]            
    end # CSV
  end # if file exists  
end

def restore_shifts
#  user_id      :integer
#  shifttype_id :integer
#  shift_status :integer
#  shift_date   :date

  filename = "../shiftdata.csv"
  
  if File.exists?(filename)
    puts "Loading Shifts from file..."

    bpastHeader = false
    
    CSV.foreach(filename) do |row|
      if !bpastHeader
        bpastHeader = true
        next
      end
    
      aShift = Shift.create!(:user_id => row[0],
                              :shift_date => row[1],
                             :shifttype_id => row[2],
                             :shift_status => row[3]
                             )                        
    end # CSV
  else
    fail "Shift Type data file not found."
  end  
end

def make_users                       
  # read users data file
  filename = "../hostdemographicsdata2011.csv"

  if File.exists?(filename) 
    puts "Loading Users From File..."
    
    File.open(filename, "r") do |aFile|
      # read the first two lines and discard
      2.times do
        sReadValue = aFile.gets
        puts "skipped: #{sReadValue}"
      end
      
      aFile.each_line do |line| 
        sfirstarray = line.split('"')
        
        if (sfirstarray.count == 3)      
          
          sfirst4 = sfirstarray[0].split(',')
          if sfirst4.count == 3
            sfirst4 = sfirst4 << ","
          end
          sEntry = sfirst4 << sfirstarray[1]
          temparray = sfirstarray[2].split(',')
          temparray.each do |sitem|
            sEntry = sEntry << sitem
          end
          
          # set variables
          sEmail = sEntry[6]
          sHomePhone = sEntry[3]
          sCellPhone = sEntry[2]
          sStreet = sEntry[4]
          sStartDate = sEntry[7]  
          sAdmin = sEntry[8] 
          sTeamleader = sEntry[9]                   
        else 
          sEntry = line.split(',')

          # set variables
          sEmail = sEntry[5]
          sHomePhone = sEntry[3]
          sCellPhone = sEntry[2]
          sStreet = sEntry[4]
          sStartDate = sEntry[6]   
          sAdmin = sEntry[7]  
          sTeamleader = sEntry[9]   
        end
        
        sHostName = sEntry[0].strip + " " + sEntry[1].strip
        if sHomePhone == ","
          sHomePhone = ""
        end
        if sCellPhone == ","
          sCellPhone = ""
        end
        sPassword = "Snowbird1"
        if !sAdmin.blank?
          sPassword = "foobar"
          if (sHostName == "Allen Maxwell")
            sPassword = "12and12"
          end
        end
        
        aHost = User.create!(:name => "#{sHostName}",
                           :fname => sEntry[0],
                           :lname => sEntry[1],
                           :email => "#{sEmail}",
                           :homephone => "#{sHomePhone} ",
                           :cellphone => "#{sCellPhone} ",
                           :street => "#{sStreet} ",
                           :city => "",
                           :state => "",
                           :zip => "",
                           :startdate => "#{sStartDate} ",
                           :password => "#{sPassword}",
                           :password_confirmation => "#{sPassword}") 
        if !sAdmin.blank?
          aHost.toggle!(:admin)
        end  
        if !sTeamleader.blank?
          aHost.toggle!(:teamleader)
        end                         
        puts "imported user: " + sHostName
      end # afile
    end # file open
  else
    fail "Shift data file not found."
  end # file exists
end # def users

def make_shifttypes
  filename = "../shifttypes2011.csv"
  
  if File.exists?(filename)
    puts "Loading Shift Types from file..."
    
    File.open(filename, "r") do |aFile|
      aFile.each_line do |line| 
        if !line.blank?
          sEntry = line.split(',')
          
          puts "shortname: " + sEntry[0]
          puts "description: " + sEntry[1]
          puts "starttime: " + sEntry[2]
          puts "endtime: " + sEntry[3]
          puts "speedcontrol: " + sEntry[4]

          aShift = Shifttype.create!(:shortname => "#{sEntry[0]}",
                             :description => "#{sEntry[1]}",
                             :starttime => "#{sEntry[2]} ",
                             :endtime => "#{sEntry[3]} ",
                             :speedcontrol => "#{sEntry[4]} ")   
          
          puts "imported shifttype: " + sEntry[0]
        end
      end
    end
  else
    Shifttype.create!(:shortname => "G1weekday",
                      :description => "Creekside",
                      :starttime => "8:00",
                      :endtime => "4:30",
                      :speedcontrol => "Big Emma 1:30, 2:30, 3:30")
                      
    Shifttype.create!(:shortname => "G2weekday",
                      :description => "Hidden Peak",
                      :starttime => "8:00",
                      :endtime => "4:30",
                      :speedcontrol => "Big Emma 1:30, 2:30, 3:30")
                      
    Shifttype.create!(:shortname => "G3weekday",
                      :description => "Chickadee",
                      :starttime => "8:00",
                      :endtime => "4:30",
                      :speedcontrol => "Big Emma 10:30, 11:30, 12:30")
                      
    Shifttype.create!(:shortname => "G4weekday",
                      :description => "Creekside Late",
                      :starttime => "9:00",
                      :endtime => "5:30",
                      :speedcontrol => "Big Emma 10:00, 11:00, 12:00")
                      
    Shifttype.create!(:shortname => "P1weekday",
                      :description => "Portico",
                      :starttime => "8:00",
                      :endtime => "4:30",
                      :speedcontrol => "10:30 Tour, SC EOB 3:00-4:00")

    Shifttype.create!(:shortname => "P2weekday",
                      :description => "Peruvian Express",
                      :starttime => "8:00",
                      :endtime => "4:30",
                      :speedcontrol => "10:30 Tour, SC EOB 3:00-4:00")
                      
    Shifttype.create!(:shortname => "P3weekday",
                      :description => "Portico",
                      :starttime => "8:00",
                      :endtime => "4:30",
                      :speedcontrol => "9:30 Tour, Mt. Presence")
                      
    Shifttype.create!(:shortname => "P4weekday",
                      :description => "Portico Late",
                      :starttime => "9:00",
                      :endtime => "5:30",
                      :speedcontrol => "9:30 Tour, Mt. Presence")
                      
                                                                                
    Shifttype.create!(:shortname => "G1weekend",
                      :description => "Creekside",
                      :starttime => "8:00",
                      :endtime => "4:30",
                      :speedcontrol => "Big Emma 1:30, 2:30, 3:30")
                      
    Shifttype.create!(:shortname => "G2weekend",
                      :description => "Hidden Peak",
                      :starttime => "8:00",
                      :endtime => "4:30",
                      :speedcontrol => "Big Emma 1:30, 2:30, 3:30")
                      
    Shifttype.create!(:shortname => "G3weekend",
                      :description => "Creekside",
                      :starttime => "8:00",
                      :endtime => "4:30",
                      :speedcontrol => "Big Emma 10:30, 11:30, 12:30")
                      
    Shifttype.create!(:shortname => "G4weekend",
                      :description => "Portico",
                      :starttime => "9:00",
                      :endtime => "5:30",
                      :speedcontrol => "Big Emma 10:00, 11:00, 12:00")
                      
    Shifttype.create!(:shortname => "G5weekend",
                      :description => "Plaza Inside Hall",
                      :starttime => "8:00",
                      :endtime => "4:30",
                      :speedcontrol => "10:30 Tour, SC EOB 3:00-4:00")

    Shifttype.create!(:shortname => "G6weekend",
                      :description => "Plaza 2nd Floor",
                      :starttime => "8:00",
                      :endtime => "4:30",
                      :speedcontrol => "10:30 Tour, SC EOB 3:00-4:00")
                      
    Shifttype.create!(:shortname => "G7weekend",
                      :description => "Creekside Late",
                      :starttime => "8:00",
                      :endtime => "4:30",
                      :speedcontrol => "9:30 Tour, Mt. Presence")
                      
    Shifttype.create!(:shortname => "G8weekend",
                      :description => "Creekside Late",
                      :starttime => "9:00",
                      :endtime => "5:30",
                      :speedcontrol => "9:30 Tour, Mt. Presence")

    Shifttype.create!(:shortname => "P1weekend",
                      :description => "Portico",
                      :starttime => "8:00",
                      :endtime => "4:30",
                      :speedcontrol => "Big Emma 1:30, 2:30, 3:30")
                      
    Shifttype.create!(:shortname => "P2weekend",
                      :description => "Peruvian Express",
                      :starttime => "8:00",
                      :endtime => "4:30",
                      :speedcontrol => "Big Emma 1:30, 2:30, 3:30")
                      
    Shifttype.create!(:shortname => "P3weekend",
                      :description => "Portico Late",
                      :starttime => "8:00",
                      :endtime => "4:30",
                      :speedcontrol => "Big Emma 10:30, 11:30, 12:30")
                      
    Shifttype.create!(:shortname => "P4weekend",
                      :description => "Portico Late",
                      :starttime => "9:00",
                      :endtime => "5:30",
                      :speedcontrol => "Big Emma 10:00, 11:00, 12:00")
                      
    Shifttype.create!(:shortname => "C1weekend",
                      :description => "Chickadee",
                      :starttime => "8:00",
                      :endtime => "4:30",
                      :speedcontrol => "10:30 Tour, SC EOB 3:00-4:00")

    Shifttype.create!(:shortname => "C2weekend",
                      :description => "Cliff Back Door",
                      :starttime => "8:00",
                      :endtime => "4:30",
                      :speedcontrol => "10:30 Tour, SC EOB 3:00-4:00")
                      
    Shifttype.create!(:shortname => "C3weekend",
                      :description => "Plaza Deck",
                      :starttime => "8:00",
                      :endtime => "4:30",
                      :speedcontrol => "9:30 Tour, Mt. Presence")
                      
    Shifttype.create!(:shortname => "C4weekend",
                      :description => "Plaza Deck",
                      :starttime => "9:00",
                      :endtime => "5:30",
                      :speedcontrol => "9:30 Tour, Mt. Presence")
                      
                      
                      

    Shifttype.create!(:shortname => "TL",
                      :description => "Team Leader",
                      :starttime => "8:00",
                      :endtime => "5:30",
                      :speedcontrol => "Roam")                                          
  end
end

def add_shifts
#  user_id      :integer
#  shifttype_id :integer
#  shift_status :integer
#  shift_date   :date

  filename = "../shifts2011.csv"
  
  if File.exists?(filename)
    puts "Loading Shifts from file..."

    File.open(filename, "r") do |aFile|
      aFile.each_line do |line| 
        if !line.blank?
          sEntry = line.split(',')
                 
          arr = sEntry[1].split("/")
          sEntry[1] = arr[1] + "-" + arr[0] + "-" + arr[2] 
          
          # convert shifttype shortname to id value
          sEntry[0] = Shifttype.where("shortname == '" + sEntry[0] + "'")[0].id

          aShift = Shift.create!(:user_id => nil,
                             :shifttype_id => "#{sEntry[0]}",
                             :shift_status => nil,
                             :shift_date => "#{sEntry[1]}")   
          
        end
      end
    end    
  else
    
    # add shifts for weekdays 
    
    8.times do |shifts|
      5.times do |days| 
        datevalue = "2011-12-15"  
        case days
          when 0 
            datevalue = "2011-12-16"
          when 1 
            datevalue = "2011-12-17"
          when 2 
            datevalue = "2011-12-18"
          when 3
            datevalue = "2011-12-19"
          when 4 
            datevalue = "2011-12-20"
          else 
            datevalue = "2011-12-21"
        end

        Shift.create!(:user_id => shifts + 1,
                  :shifttype_id => shifts + 1,
                  :shift_date => datevalue.to_date)
      end # days
    end # shifts
  end
  puts "done"
end

def add_shifts_from_syncfile
#  user_id      :integer
#  shifttype_id :integer
#  shift_status :integer
#  shift_date   :date

  filename = "../shiftdataFromSP.csv"
  @MainStartDate = Date.new(2011, 12, 23)
  @MainEndDate = Date.new(2012, 1, 1)
  @EarliestDate = Date.new(2011, 12, 5)
  @LatestDate = Date.new(2012, 11, 1)
   
  if File.exists?(filename)
    puts "Loading Shifts from file..."

    File.open(filename, "r") do |aFile|
      aFile.each_line do |line| 
        if !line.blank?        
          sEntry = line.split('|')
          
          @shifttype = sEntry[0].strip
          @description = sEntry[1].strip
          @shiftdate = sEntry[2]
          @hostid = sEntry[3]
          @name = sEntry[4]
          @acct = sEntry[5]
          @starttime = sEntry[6]
          @endtime = sEntry[7]
                    
          @shiftstatus = 1 # default to worked
          @datearr = @shiftdate.split('-')    
    
          @adate = Date.new(@datearr[0].to_i, @datearr[1].to_i, @datearr[2].to_i)

          if (@adate < @EarliestDate) || (@adate > @LatestDate)
            next
          end
          
          if @name.blank?
            @name = ""
          end
          
          # set user_id value from supplied @name/@acct variable read from import file
          @user_id = GetUserIDFromNameAndAcctFieldValues(@name, @acct)          
          
          # set shifttypeid based on id of shifttype
          # look up shifttype based on dayofweek, time of year, and shift_title
          @shifttypeid = GetShiftTypeFromShift_titleAndDate(@shiftdate, @shifttype, @description)

          if line.blank?
            line = "BLANK LINE"
          end
          
          if @user_id.nil? 
            @user_id = 0
          end
          if @shifttypeid.nil?
            @shifttypeid = 0
          end
          
          if ((@user_id < 0) && (@shifttypeid < 0))
            puts "Both Bad---> " + line                
            return
          elsif (@user_id < 0)
            puts "User Bad---> ID < 0 => " + line
          elsif (@shifttypeid < 0)
            puts "Shift Bad---> shifttypeid < 0 => " + line
          else
            if @user_id == 0
              @user_id = nil
            end
            if @shifttypeid == 0
              puts "Bad shift type ID: " + line
            else  
              aShift = Shift.create!(:user_id => @user_id,
                             :shifttype_id => @shifttypeid,
                             :shift_status => @shiftstatus,
                             :shift_date => @shiftdate) 
            end
          end # if user or shift < 0          
          
        end # if line not blank
      end # aFile do
    end # File open
  end # file exists
end # def add users from sync file

def GetUserIDFromNameAndAcctFieldValues(name, acct)
  if name.blank?
    0
    return
  end
  
  if (name.upcase().include?("SNOWBIRDMOUNTAI\\"))
    name = name[16..200]
  end
  
  
  # special hard coded case items:
  if name.upcase == "OPEN"
    name = "Nancy Seamons"
  elsif name.upcase == "MADELYNMOYLE"
    name = "Madelyn Corey"
  elsif name.downcase == "henrydeutsch"
    name = "Henry Deutsch"
  elsif name.downcase == "michaelquaranto"
    name = "Michael Quaranto"
  elsif name.downcase == "jamesgasik"
    name = "James Gasik"
  elsif (name.downcase == "patriciabailey") ||
        (name.downcase == "patricia bailey")
    name = "Trish Bailey"
  elsif name.downcase == "kellykrantz"
    name = "Kelly Krantz"
  elsif name.downcase == "kristineumble"
    name = "Kristine Umble"
  elsif name.downcase == "jeremywilz"
    name = "Jeremy Wilz"
  elsif name.downcase == "jameswarren"
    name = "James Warren"
  elsif name.downcase == "torilima"
    name = "Tori Lima"
  elsif name.downcase == "paulafuhrman"
    name = "Paula Fuhrman"
  elsif name.downcase == "hollybirich"
    name = "Holly Birich"
  elsif name.downcase == "kramic"
    name = "Michael Krause"
  elsif name.downcase == "margaretmatthews"
    name = "Maggie Matthews"
  elsif name.downcase == "waynerogers"
    name = "Wayne Rogers"
  elsif name.downcase == "angiewojtala"
    name = "Angie Wojtala"
  elsif name.downcase == "000"
    name = "Bunny Sterin"
  elsif name.downcase == "margaret matthews"
    name = "Maggie Matthews"
  elsif name.downcase == "elainagillespie"
    name = "Elaina Gillespie"
  elsif name.downcase == "christinedennis"
    name = "Christine Dennis"
  end  
  # end of hard coded matching section
  
  hosts = User.where("upper(name) like '%" + name.upcase() + "%'")
  
  if (!hosts.nil?) && (!hosts.empty?) && !hosts[0].nil? && !hosts[0].id.nil?
      hosts[0].id    
  else
    -1
  end
end

def GetShiftTypeFromShift_titleAndDate(shiftdate, shifttype, description)
  if shifttype.upcase().include?("SHADOW")
    shift = Shifttype.where("shortname like 'SH%'")
    if shift[0].nil?
      -1
    else
      if !shift[0].nil?
        shift[0].id 
      else
        -1
      end
    end
  elsif shifttype.upcase().include?("TEAM LEAD") || description.upcase().include?("TEAM LEAD")
    shift = Shifttype.where("shortname like 'TL%'")
    if shift[0].nil?
      -1
    else 
      if !shift[0].nil?
        shift[0].id 
      else
        -1
      end
    end
  else
    
    
    # process all shifts
    prefix = description[0...2].strip
    
    if prefix.blank?
      if shifttype == "Peruvian 1"
        prefix = "P1"
      elsif shifttype == "Peruvian 2"
        prefix = "P2"
      elsif shifttype == "Peruvian 3"
        prefix = "P3"
      elsif shifttype == "Peruvian 4"
        prefix = "P4"
      elsif shifttype == "Chickadee 1"
        prefix = "C1"
      elsif shifttype == "Chickadee 3"
        prefix = "C3"
      elsif shifttype == "Chickadee 4"
        prefix = "C3"
      elsif shifttype == "Gad 1"
        prefix = "G1"
      elsif shifttype == "Gad 3"
        prefix = "G3"
      elsif shifttype == "Gad 5"
        prefix = "G5"
      elsif shifttype == "Gad 7"
        prefix = "G7"
      elsif shifttype == "Trainer"
        prefix = "TR"
      else
        -1
        return
      end
    end
           
    dow = @adate.strftime("%a").upcase
    
    if (dow == "SAT") || (dow == "SUN")
      tstshortname = prefix + "weekend"
    elsif ((@adate >= @MainStartDate) && (@adate <= @MainEndDate))
      tstshortname = prefix + "weekend"
    elsif (@adate == Date.new(2012, 1, 16)) || (@adate == Date.new(2012, 2, 20))
      tstshortname = prefix + "weekend"
    elsif (@adate == Date.new(2011, 12, 21)) || (@adate == Date.new(2011, 12, 22))
      tstshortname = prefix + "weekend"
    elsif (dow == "FRI")
      tstshortname = prefix + "friday"
    elsif (dow == 'MON') || (dow == "TUE") || (dow == "WED") || (dow == "THU")
      tstshortname = prefix + "weekday"
    end
    if (tstshortname == "Pofriday") && (shifttype == "Peruvian 1")
      tstshortname = "P1friday"
    end
    if shifttype == "Trainer"
      tstshortname = "Trainer"
    end
            
    shift = Shifttype.where("lower(shortname) like '#{tstshortname.downcase()}%'")
    if shift.nil? || shift[0].nil?
      #puts "nil:" + dow + "-" + shiftdate + "-" + shifttype + "-" + description + "--tst: [" + tstshortname + "]"
        puts "shifttype:[" + shifttype + "]"
        puts "description:[" + description + "]"
        puts "date:[" + shiftdate + "]"
        puts "dow:[" + dow + "]"
        puts "tstshortname: [" + tstshortname + "]"
        puts "adate: [" + @adate.to_s + "]"
      -1
    else 
      #puts "good:" + shiftdate + shifttype + "-" + description
      shift[0].id
    end
  end  
end


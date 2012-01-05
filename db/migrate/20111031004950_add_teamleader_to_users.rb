class AddTeamleaderToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :teamleader, :boolean
  end
  
  def self.down
    remove_column :users, :teamleader
  end
end

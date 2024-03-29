class CreateLocalevents < ActiveRecord::Migration
  def self.up
    create_table :localevents do |t|
      t.string :when
      t.string :time
      t.string :location
      t.string :contact
      t.string :name
      t.string :description
      t.string :website

      t.timestamps
    end
  end
  
  def self.down
    drop_table :localevents
  end
end

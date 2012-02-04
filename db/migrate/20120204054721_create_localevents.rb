class CreateLocalevents < ActiveRecord::Migration
  def change
    create_table :localevents do |t|
      t.datetime :when
      t.string :location
      t.string :contact
      t.string :name
      t.string :description
      t.string :website

      t.timestamps
    end
  end
end

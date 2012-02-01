class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string :name
      t.string :email
      t.boolean :service
      t.boolean :events

      t.timestamps
    end
  end
end

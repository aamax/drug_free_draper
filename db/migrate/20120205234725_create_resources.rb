class CreateResources < ActiveRecord::Migration
  def change
    create_table :resources do |t|
      t.string :name
      t.string :description
      t.string :website
      t.string :phone
      t.string :contact
      t.string :category

      t.timestamps
    end
  end
end

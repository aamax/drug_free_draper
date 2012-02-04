# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120204054721) do

  create_table "events", :force => true do |t|
    t.datetime "when"
    t.string   "name"
    t.string   "description"
    t.string   "location"
    t.string   "contact"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "localevents", :force => true do |t|
    t.datetime "when"
    t.string   "location"
    t.string   "contact"
    t.string   "name"
    t.string   "description"
    t.string   "website"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.boolean  "service"
    t.boolean  "events"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "fname"
    t.string   "midinit"
    t.string   "lname"
    t.string   "email"
    t.string   "login"
    t.string   "homephone"
    t.string   "cellphone"
    t.string   "street"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.integer  "startdate"
    t.boolean  "admin",              :default => false
    t.string   "encrypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "teamleader"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end

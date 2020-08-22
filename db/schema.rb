# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_200_821_211_756) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'class_groups', force: :cascade do |t|
    t.integer 'responsible'
    t.string 'discipline'
    t.string 'class_code'
    t.boolean 'active'
    t.date 'expiration_date'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'people', force: :cascade do |t|
    t.integer 'profile'
    t.string 'name'
    t.string 'registration'
    t.string 'email'
    t.string 'password'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'person_classes', force: :cascade do |t|
    t.integer 'person_id'
    t.integer 'class_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'responses', force: :cascade do |t|
    t.integer 'person_id'
    t.integer 'task_id'
    t.text 'response_value'
    t.text 'annotation_person'
    t.integer 'status'
    t.float 'grade'
    t.text 'observation_responsible'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'tasks', force: :cascade do |t|
    t.string 'title'
    t.integer 'class_id'
    t.text 'description'
    t.integer 'status'
    t.date 'expiration_date'
    t.boolean 'active'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end
end
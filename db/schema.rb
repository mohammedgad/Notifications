# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_210_313_231_821) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'notification_translations', force: :cascade do |t|
    t.bigint 'notification_id', null: false
    t.string 'locale', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'message'
    t.index ['locale'], name: 'index_notification_translations_on_locale'
    t.index ['notification_id'], name: 'index_notification_translations_on_notification_id'
  end

  create_table 'notifications', force: :cascade do |t|
    t.string 'channel_type', null: false, comment: 'notifications types [sms| push]'
    t.json 'filter', null: false, comment: 'user filters'
    t.string 'status', null: false, comment: 'notifications status [pending| running| finished]'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'users', force: :cascade do |t|
    t.string 'uuid', comment: 'user global uuid from users service'
    t.string 'name', comment: 'user name'
    t.string 'phone', comment: 'user phone'
    t.date 'birthdate', comment: 'user birth date'
    t.string 'android_key', comment: 'user android key for push notification'
    t.string 'ios_key', comment: 'user ios key for push notification'
    t.string 'locale', comment: 'user preferred language'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end
end

# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if User.count < 1000
  1..1000.times do
    User.create(
      uuid: Faker::Internet.uuid,
      name: Faker::Name.name,
      phone: Faker::PhoneNumber.cell_phone,
      birthdate: Faker::Date.birthday(min_age: 18, max_age: 65),
      android_key: Faker::Internet.uuid,
      ios_key: Faker::Internet.uuid,
      locale: %i[ar en].sample
    )
  end
end

if Notification.count < 2
  %w[sms push].each do |channel_type|
    Notification.create(
      channel_type: channel_type,
      filter: { 'locale' => 'en' },
      status: 'pending',
      message_ar: 'لا بد أن أوضح لك أن كل هذه الأفكار',
      message_en: "This is a #{channel_type} message"
    )
  end
end

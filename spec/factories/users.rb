# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    uuid { Faker::Internet.uuid }
    name { Faker::Name.name }
    phone { Faker::PhoneNumber.cell_phone }
    birthdate { Faker::Date.birthday(min_age: 18, max_age: 65) }
    android_key { Faker::Internet.uuid }
    ios_key { Faker::Internet.uuid }
    locale { %i[ar en].sample }
  end
end

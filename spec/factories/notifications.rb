# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    channel_type { %w[sms push].sample }
    filter { { 'search_name_query' => 'gadz', 'locale' => 'en' } }
    status { %w[pending fired].sample }
    message_ar { 'لا بد أن أوضح لك أن كل هذه الأفكار' }
    message_en { Faker::Lorem.characters(number: 160) }

    factory :notification_ar do
      message_ar { 'لا بد أن أوضح لك أن كل هذه الأفكار' }
    end

    factory :notification_en do
      message_en { Faker::Lorem.characters(number: 160) }
    end
  end
end

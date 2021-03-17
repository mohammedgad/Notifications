# frozen_string_literal: true

class SmsWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'sms_notifications', rate: { name: 'sms_notifications_rate_limit', limit: ENV['SMS_LIMIT_PER_MINUTE'], period: 60 }

  def perform(user_phone, notification_message)
    Sns.send_sms(user_phone, notification_message)
  end
end

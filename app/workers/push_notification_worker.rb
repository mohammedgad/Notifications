# frozen_string_literal: true

class PushNotificationWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'push_notifications', rate: { name: 'push_notifications_rate_limit', limit: ENV['PUSH_LIMIT_PER_MINUTE'], period: 60 }

  def perform(target_arns, notification_message)
    Sns.send_push_notification(target_arns, notification_message)
  end
end

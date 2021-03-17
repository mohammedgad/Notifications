# frozen_string_literal: true

class NotificationWorker
  include Sidekiq::Worker

  def perform(notification_id)
    notification = Notification.find(notification_id)
    raise 'Notification not found.' unless notification

    users =
      User
      .select(:phone, :android_key, :ios_key, :locale)
      .construst_query_from_filters(notification.filter)

    case notification.channel_type
    when 'sms'
      users.each do |user|
        SmsWorker.perform_async(user.phone, notification.localed_message(user))
      end
    when 'push'
      users.each do |user|
        PushNotificationWorker.perform_async(user.android_key, notification.localed_message(user)) unless user.android_key.nil?
        PushNotificationWorker.perform_async(user.ios_key, notification.localed_message(user)) unless user.ios_key.nil?
      end
    else
      raise 'Notification channel type is not supported.'
    end
  end
end

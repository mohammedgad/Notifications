# frozen_string_literal: true

json.extract! notification, :id, :channel_type, :filter, :status, :created_at, :updated_at
json.message_en notification.message_en
json.message_ar notification.message_ar
json.url notification_url(notification)

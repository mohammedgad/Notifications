# frozen_string_literal: true

class Notification < ApplicationRecord
  extend Enumerize
  translates :message, fallbacks_for_empty_translations: true
  globalize_accessors locales: %i[en ar], attributes: %i[message]

  validates :message_en, presence: true, length: { maximum: 160 }
  validates :message_ar, presence: true, length: { maximum: 70 }
  validates :channel_type, :status, presence: true

  enumerize :channel_type, in: %i[sms push], scope: true
  enumerize :status, in: %i[pending fired], default: :pending, scope: true

  def localed_message(user)
    send("message_#{user.locale}")
  end
end

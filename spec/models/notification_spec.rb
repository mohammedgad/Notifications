# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'Validation' do
    context 'Presence' do
      it { %i[message_ar message_en channel_type].each { |key| should validate_presence_of(key) } }
    end

    context 'Length' do
      it { %i[message_ar].each { |key| should validate_length_of(key).is_at_most(70) } }
      it { %i[message_en].each { |key| should validate_length_of(key).is_at_most(160) } }
    end

    context 'Enum' do
      it { should enumerize(:channel_type).in(:sms, :push) }
      it { should enumerize(:status).in(:pending, :fired).with_default(:pending) }
    end
  end
end

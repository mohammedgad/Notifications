# frozen_string_literal: true

module Sns
  def client
    @client ||= new_client
  end

  def new_client(attributes = {})
    options = {
      region: ENV['AWS_REGION'],
      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
    }

    options[:endpoint] = ENV['SNS_ENDPOINT'] unless ENV['SNS_ENDPOINT'].nil?

    client = Aws::SNS::Client.new(options)
    client.set_sms_attributes({
                                attributes: {
                                  'DefaultSMSType' => 'Transactional'
                                }.merge(attributes)
                              })

    client
  end

  def send_sms(phone_number, message, client = new_client)
    client.publish(phone_number: phone_number, message: message)
  end

  def send_push_notification(device_key, message, client = new_client)
    client.publish(target_arn: device_key, message: message)
  end

  def fan_out_push_notifications(message, client = new_client)
    client.publish(topic_arn: 'send-to-all', message: message)
  end

  module_function :client, :new_client, :send_sms, :send_push_notification, :fan_out_push_notifications
end

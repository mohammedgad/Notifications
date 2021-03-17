# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'notifications', type: :request do
  path '/notifications' do
    get 'List All Notifications' do
      tags 'Notifications API'
      security [ basic_auth: [] ]

      consumes 'application/json'
      produces 'application/json'
      
      response 200, 'Successful' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('username:password')}" }
        let!(:notifications) { create_list(:notification, 3) }

        schema '$ref' => "#/components/schemas/NotificationsModel"

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data.pluck('id').sort).to eq notifications.map(&:id).sort
        end
      end
    end

    post 'Create a Notification' do
      tags 'Notifications API'
      security [ basic_auth: [] ]

      parameter name: :notification, in: :body, schema: {
        type: :object,
        properties: {
          notification: {
            type: :object,
            properties: {
              message_en: { type: :string, description: 'notification english message' },
              message_ar: { type: :string, description: 'notification arabic message' },
              channel_type: { type: :string, description: 'notification channel type sms or push notification' },
              filter: { type: :object, description: 'notification users filters' }
            },
            required: %w[message_en message_ar channel_type filter]
          }
        },
        required: %w[notification],
        example: {
          notification: {
            message_en: 'English Message',
            message_ar: 'لا بد أن أوضح لك أن كل هذه الأفكار',
            channel_type: 'sms',
            filter: {"with_locale": "en"}
          }
        }
      }

      consumes 'application/json'
      produces 'application/json'

      response 201, 'Successful' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('username:password')}" }
        let!(:notification) do
          {
            notification: {
              message_en: 'English Message',
              message_ar: 'Arabic Message',
              channel_type: 'sms',
              filter: {"with_locale": "en"}
            }
          }
          end

        schema '$ref' => "#/components/schemas/NotificationModel"

        run_test! do |response|
          data = JSON.parse(response.body)
          %w[message_en message_ar channel_type].each do |key|
            expect(data[key]).to eq notification[:notification][key.to_sym]
          end
        end
      end
    end
  end

  path '/notifications/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'notification id'

    get 'Show a Notification' do
      tags 'Notifications API'
      security [ basic_auth: [] ]

      consumes 'application/json'
      produces 'application/json'
      
      response 200, 'Successful' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('username:password')}" }
        let!(:notification) { create(:notification) }
        let!(:id) { notification.id }

        schema '$ref' => "#/components/schemas/NotificationModel"

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["channel_type"]).to eq notification[:channel_type]
          expect(data["message_ar"]).to eq notification.message_ar
          expect(data["message_en"]).to eq notification.message_en
        end
      end

      response 404, 'Notification not found' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('username:password')}" }
        let!(:id) { 0 }

        schema '$ref' => "#/components/schemas/error"

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["code"]).to eq "404"
          expect(data["status"]).to eq "not_found"
        end
      end
    end

    put 'Update a Notification' do
      tags 'Notifications API'
      security [ basic_auth: [] ]

      parameter name: :notification, in: :body, schema: {
        type: :object,
        properties: {
          notification: {
            type: :object,
            properties: {
              message_en: { type: :string, description: 'notification english message' },
              message_ar: { type: :string, description: 'notification arabic message' },
              channel_type: { type: :string, description: 'notification channel type sms or push notification' },
              filter: { type: :object, description: 'notification users filters' }
            },
            required: %w[message_en message_ar channel_type filter]
          }
        },
        required: %w[notification],
        example: {
          notification: {
            message_en: 'English Message',
            message_ar: 'لا بد أن أوضح لك أن كل هذه الأفكار',
            channel_type: 'sms',
            filter: {"with_locale": "en"}
          }
        }
      }

      consumes 'application/json'
      produces 'application/json'

      response 200, 'Successful' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('username:password')}" }
        let!(:old_notification) { create(:notification, status: :pending) }
        let!(:id) { old_notification.id }
        let!(:notification) do
          {
            notification: {
              message_en: 'English Message',
              message_ar: 'Arabic Message',
              channel_type: 'sms',
              filter: {"with_locale": "en"}
            }
          }
          end

        schema '$ref' => "#/components/schemas/NotificationModel"

        run_test! do |response|
          data = JSON.parse(response.body)
          %w[message_en message_ar channel_type].each do |key|
            expect(data[key]).to eq notification[:notification][key.to_sym]
          end
        end
      end

      response 404, 'Notification not found' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('username:password')}" }
        let!(:notification) { {} }
        let!(:id) { 0 }

        schema '$ref' => "#/components/schemas/error"

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["code"]).to eq "404"
          expect(data["status"]).to eq "not_found"
        end
      end

      response 422, 'Fired notifications can\'t be updated' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('username:password')}" }
        let!(:old_notification) { create(:notification, status: :fired) }
        let!(:id) { old_notification.id }
        let!(:notification) { {} }
        
        schema '$ref' => "#/components/schemas/error"

        run_test!
      end
    end

    delete 'Delete a Notification' do
      tags 'Notifications API'
      security [ basic_auth: [] ]

      consumes 'application/json'
      produces 'application/json'

      response 204, 'Successful' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('username:password')}" }
        let!(:notification) { create(:notification, status: :pending) }
        let!(:id) { notification.id }

        run_test!
      end

      response 404, 'Notification not found' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('username:password')}" }
        let!(:notification) { {} }
        let!(:id) { 0 }

        schema '$ref' => "#/components/schemas/error"

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["code"]).to eq "404"
          expect(data["status"]).to eq "not_found"
        end
      end

      response 422, 'Fired notifications can\'t be deleted' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('username:password')}" }
        let!(:old_notification) { create(:notification, status: :fired) }
        let!(:id) { old_notification.id }
        let!(:notification) { {} }
        
        schema '$ref' => "#/components/schemas/error"

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["code"]).to eq "422"
          expect(data["status"]).to eq "unprocessable_entity"
          expect(data["message"]).to eq "Fired notifications can't be deleted"
        end
      end
    end
  end


  path '/notifications/{id}/fire' do
    parameter name: 'id', in: :path, type: :integer, description: 'notification id'

    post 'Fire a Notification' do
      tags 'Notifications API'
      security [ basic_auth: [] ]

      consumes 'application/json'
      produces 'application/json'
      
      response 200, 'Successful' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('username:password')}" }
        let!(:notification) { create(:notification) }
        let!(:id) { notification.id }

        schema '$ref' => "#/components/schemas/NotificationModel"

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["channel_type"]).to eq notification[:channel_type]
          expect(data["message_ar"]).to eq notification.message_ar
          expect(data["message_en"]).to eq notification.message_en
          expect(notification.reload.status).to eq 'fired'
        end
      end

      response 404, 'Notification not found' do
        let(:Authorization) { "Basic #{::Base64.strict_encode64('username:password')}" }
        let!(:id) { 0 }

        schema '$ref' => "#/components/schemas/error"

        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data["code"]).to eq "404"
          expect(data["status"]).to eq "not_found"
        end
      end
    end
  end
end

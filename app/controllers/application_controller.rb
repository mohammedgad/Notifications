# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  
  before_action :set_default_response_format
  http_basic_authenticate_with name: 'username', password: 'password'

  private

  def set_default_response_format
    request.format = :json
  end
end

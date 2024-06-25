# frozen_string_literal: true

require 'rest_client'
require 'base64'
require_relative '../../../config/environment'

module Ptime
  class Client
    def initialize
      @base_url = "#{ENV.fetch('PTIME_BASE_URL')}/api/v1/"
    end

    def get(endpoint, params = {})
      request(:get, @base_url + endpoint, params)
    end

    private

    def request(method, path, params = nil)
      path = "#{path}?#{URI.encode_www_form(params)}"
      response = RestClient.send(method, path, headers)
      JSON.parse(response.body)
    rescue RestClient::BadRequest => e
      msg = response_error_message(e)
      e.message = msg if msg.present?
      raise e
    end

    def response_error_message(exception)
      JSON.parse(exception.response.body).dig('error', 'message')
    rescue # do not fail if response is not JSON
      nil
    end

    def headers
      {
        authorization: "Basic #{basic_token}",
        content_type: :json,
        accept: :json
      }
    end

    def basic_token
      Base64.encode64("#{ENV.fetch('PTIME_API_USERNAME')}:#{ENV.fetch('PTIME_API_PASSWORD')}")
    end
  end
end
require 'rest_client'
require 'base64'
require_relative '../../../config/environment'

module Ptime
  class Client
    BASE_URL = "#{ENV.fetch('PTIME_BASE_URL')}/api/v1/".freeze

    def get(endpoint, params = {})
      request(:get, BASE_URL + endpoint, params)
    end

    private

    def request(method, path, params = nil)
      response = RestClient.send(method, path, headers.merge(params))
      JSON.parse(response.body)
    rescue RestClient::BadRequest => e
      msg = response_error_message(e)
      e.message = msg if msg.present?
      raise e
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

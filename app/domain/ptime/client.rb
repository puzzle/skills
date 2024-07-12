# frozen_string_literal: true

require 'rest_client'
require 'base64'

module Ptime
  class Client
    def initialize
      @base_url = "#{ENV.fetch('PTIME_BASE_URL')}/api/v1/"
    end

    def request(method, endpoint, params = {})
      path = @base_url + endpoint
      if ENV['PTIME_API_ACCESSIBLE'].nil? && last_ptime_api_request_more_than_5_minutes
        send_request_and_parse_response(method, path, params)
      else
        skills_database_request
      end
    rescue RestClient::ExceptionWithResponse
      skills_database_request
    end

    private

    def response_error_message(exception)
      JSON.parse(exception.response.body).dig('error', 'message')
    rescue JSON::ParserError # rescue only JSON parsing errors
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

    def last_ptime_api_request_more_than_5_minutes
      last_request_time = ENV.fetch('LAST_PTIME_API_REQUEST', nil)
      return true if last_request_time.nil?

      last_request_time.to_datetime <= 5.minutes.ago
    end

    def send_request_and_parse_response(method, path, params)
      path = "#{path}?#{URI.encode_www_form(params)}" if method == :get
      response = RestClient.send(method, path, headers)
      JSON.parse(response.body)
    end

    def skills_database_request
      ENV['PTIME_API_ACCESSIBLE'] = 'false'
      ENV['LAST_PTIME_API_REQUEST'] = DateTime.current.to_s
    end
  end
end

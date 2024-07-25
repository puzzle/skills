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
      if last_ptime_api_request_more_than_5_minutes
        send_request_and_parse_response(method, path, params)
      else
        raise CustomExceptions::PTimeError, 'Error'
      end
    rescue RestClient::ExceptionWithResponse
      raise CustomExceptions::PTimeError, 'Error'
    end

    private

    # Currently not in use can be removed
    def response_error_message(exception)
      JSON.parse(exception.response.body).dig('error', 'message')
    rescue JSON::ParserError # rescue only JSON parsing errors
      nil
    end

    def last_ptime_api_request_more_than_5_minutes
      last_request_time = ENV.fetch('LAST_PTIME_API_REQUEST', nil)
      return true if last_request_time.nil?

      last_request_time.to_datetime <= 5.minutes.ago
    end

    def ptime_request(method, url)
      RestClient::Request.new(
        :method => method,
        :url => url,
        :user => ENV.fetch('PTIME_API_USERNAME'),
        :password => ENV.fetch('PTIME_API_PASSWORD'),
        :headers => { :accept => :json, :content_type => :json }
      )
    end

    def send_request_and_parse_response(method, url, params)
      url += "?#{params.to_query}" if method == :get && params.present?
      response = ptime_request(method, url).execute
      JSON.parse(response.body, symbolize_names: true)[:data]
    end
  end
end

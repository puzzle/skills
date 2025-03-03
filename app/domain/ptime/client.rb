# frozen_string_literal: true

require 'rest_client'
require 'base64'

module Ptime
  class Client
    def initialize
      @base_url = "#{ENV.fetch('PTIME_BASE_URL')}/api/v1/"
    end

    def request(method, endpoint, params = {})
      url = @base_url + endpoint

      if request_allowed?
        execute_request(method, url, params)
      else
        raise CustomExceptions::PTimeTemporarilyUnavailableError, 'PTime is temporarily unavailable'
      end
    end

    private

    def request_allowed?
      last_request_time = ENV.fetch('LAST_PTIME_ERROR', nil)
      return true if last_request_time.nil?

      last_request_time.to_datetime <= 5.minutes.ago
    end

    def build_request(method, url)
      RestClient::Request.new(
        :method => method,
        :url => url,
        :user => ENV.fetch('PTIME_API_USERNAME'),
        :password => ENV.fetch('PTIME_API_PASSWORD'),
        :headers => { :accept => :json, :content_type => :json }
      )
    end

    def execute_request(method, url, params)
      url += "?#{params.to_query}" if method == :get && params.present?
      response = build_request(method, url).execute
      JSON.parse(response.body, symbolize_names: true)[:data]
    rescue RestClient::ExceptionWithResponse
      raise CustomExceptions::PTimeClientError, 'Error'
    end
  end
end

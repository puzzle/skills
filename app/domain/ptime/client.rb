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

      execute_request(method, url, params)
    end

    private

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
      raise PtimeExceptions::PTimeClientError, 'An unexpected error occurred'
    end
  end
end
# frozen_string_literal: true

require 'rest_client'
require 'base64'

module Ptime
  class Client
    def initialize(provider_data)
      @base_url = "#{provider_data['BASE_URL']}/api/v1/"
      @provider_api_username = provider_data['API_USERNAME']
      @provider_api_password = provider_data['API_PASSWORD']
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
        :user => @provider_api_username,
        :password => @provider_api_password,
        :headers => { :accept => :json, :content_type => :json }
      )
    end

    def execute_request(method, url, params)
      url += "?#{params.to_query}" if method == :get && params.present?
      response = build_request(method, url).execute
      JSON.parse(response.body, symbolize_names: true)[:data]
    rescue RestClient::ExceptionWithResponse
      raise PtimeExceptions::PtimeClientError, 'An unexpected error occurred while fetching data'
    end
  end
end

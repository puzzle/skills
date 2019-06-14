module PeopleSync
  class Base
    attr_reader :url, :username, :password
  
    def initialize
      @url = ENV['RAILS_API_URL']
      @username = ENV['RAILS_API_USER']
      @password = ENV['RAILS_API_PASSWORD']
    end
  
    def config_valid?
      config_present? && url_valid?
    end

    def people
      raise 'implement in subclass'
    end

    def updated_people
      raise 'implement in subclass'
    end

    private
  
    def config_present?
      (url && username && password) ? true : false
    end
  
    def url_valid?
      uri = URI.parse(url) rescue false
      uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)
    end
  end
end

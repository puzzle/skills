class PuzzleTime
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
    people = JSON.parse(fetch_people)['data']
    PeopleFilter.new(people).filter
  end

  def updated_people
    last_runned_job = Delayed::Job.where(queue: 'sync_data').last
    if last_runned_job
      params = { last_run_at: last_runned_job.run_at }
      updated_people = JSON.parse(fetch_people(params))['data']
      PeopleFilter.new(updated_people).filter
    else
      people
    end
  end

  private

  # get people from API
  def fetch_people(params = nil)
    uri = uri(params)
    http = http(uri)
    request = request(uri)
    response = send_request(http, request)
    check_response(response)
  end

  def uri(params)
    uri = URI.parse(url)
    uri.query = URI.encode_www_form(params) if params
    uri
  end

  def http(uri)
    Net::HTTP.new(uri.host, uri.port)
  end

  def request(uri)
    request = Net::HTTP::Get.new(uri.request_uri)
    request['Accept'] = 'application/vnd.api+json'
    request['Authorization'] = auth_token
    request
  end

  def send_request(http, request)
    begin
      http.request(request)
    rescue Errno::ECONNREFUSED
      raise 'server not available'
    rescue Errno::ETIMEDOUT
      raise 'connection timeout'
    end
  end

  def check_response(response)
    if response.code == '200'
      response.body
    elsif response.code == '401'
      raise 'unauthorized'
    end
  end

  def auth_token
    credentials = Base64::encode64("#{username}:#{password}")
    "Basic #{credentials}"
  end

  def config_present?
    (url && username && password) ? true : false
  end

  def url_valid?
    uri = URI.parse(url) rescue false
    uri.kind_of?(URI::HTTP) || uri.kind_of?(URI::HTTPS)
  end
end

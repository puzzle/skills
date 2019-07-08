module PeopleSync
  class PuzzleTime < Base
    # all people from remote system
    def people
      people = JSON.parse(fetch_people)['data']
      PeopleFilter.new(people).filter
    end
  
    # updated people from puzzle time
    def updated_people
      if last_runned_at
        params = { update_since: last_runned_at }
        updated_people = JSON.parse(fetch_people(params))['data']
        PeopleFilter.new(updated_people).filter
      else
        people
      end
    end
  
    private

    def last_runned_at
      job = SynchronizeJob.find_by(name: 'people_sync')
      job.last_runned_at if job
    end
  
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
  end
end

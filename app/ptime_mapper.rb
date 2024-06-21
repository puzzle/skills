require 'uri'
require 'net/http'
require 'active_record'
require_relative '../config/environment'

def fetch_ptime_data
  url = URI('<base-url>/api/v1/employees')

  https = Net::HTTP.new(url.host, url.port)
  https.use_ssl = true

  request = Net::HTTP::Get.new(url)
  request['Authorization'] = 'Basic <authentication-token>'

  response = https.request(request)
  @ptime_people = response.read_body
end

def load_skills_data
  @skills_people = Person.all
end

load_skills_data
puts @skills_people.pluck(:name)

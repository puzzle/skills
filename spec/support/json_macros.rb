module JsonMacros
  def json
    JSON.parse(response.body)
  end
end

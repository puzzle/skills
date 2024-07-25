module JsonHelpers

  def json_data(filename:)
    file_fixture("json/#{filename}.json").read
  end
end

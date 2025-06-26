module JsonHelpers

  def fixture_data(filename, symbolize_names= true)
    file_content= file_fixture("json/#{filename}.json").read
    JSON.parse(file_content, symbolize_names: symbolize_names)
  end
end
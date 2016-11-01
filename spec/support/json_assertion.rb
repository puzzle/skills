module JsonAssertion
  def json_object_includes_keys(json, keys)
    keys.each do |k|
      expect(json).to include(k)
    end
  end
end

module ErrorSerializer
  def self.serialize(errors)
    return if errors.nil?
    json = {}

    new_hash = errors.to_hash(true).map do |k, v|
      v.map do |msg|
        { id: k, title: msg }
      end
    end

    json[:errors] = new_hash.flatten
    json
  end
end

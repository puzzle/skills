module PtimeExceptions
  class PtimeClientError < StandardError; end
  class PersonUpdateWithPtimeDataFailed < StandardError; end
  class InvalidProviderConfig < StandardError; end
end

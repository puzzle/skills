module PtimeExceptions
  class PtimeClientError < StandardError; end
  class PtimeBaseUrlNotSet < StandardError; end
  class PersonUpdateWithPtimeDataFailed < StandardError; end
end

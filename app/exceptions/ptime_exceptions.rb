module PtimeExceptions
  class PtimeClientError < StandardError; end
  class PtimeBaseUrlNotSet < StandardError; end
  class PersonUpdateWithPTimeDataFailed < StandardError; end
end

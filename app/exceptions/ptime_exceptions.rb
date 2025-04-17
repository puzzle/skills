module PtimeExceptions

  class PTimeClientError < StandardError; end
  class PTimeTemporarilyUnavailableError < StandardError; end

end
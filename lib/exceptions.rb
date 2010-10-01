module PivotalDoc
  class PivotalDocException < Exception
  end
  class FormatNotSupported < PivotalDocException
    def initialize(format)
      @format= format
    end
    
    def message
      "The format (#{@format}) is not currently supported"
    end
  end
end
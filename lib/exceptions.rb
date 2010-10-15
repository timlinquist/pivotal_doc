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
  class TemplateNonExistent < PivotalDocException
    def initialize(template_name)
      @template_name= template_name
    end
    
    def message
      "The template named \"#{@template_name}\" doesn't exist?"
    end    
  end
end
module PivotalDoc
  class LabelFilter
    attr_reader :project
    attr_accessor :label
    
    def initialize(project, label)
      @project= project
      @label= label
    end
    
    def stories
      PT::Story.all(@project, {:label=>@label})
    end
  end
end
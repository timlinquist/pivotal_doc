module PivotalDoc
  class Sprint
    include Work
    
    attr_reader :project
    attr_reader :iteration

    def initialize(project)
      @project= project
      @iteration= PT::Iteration.current(project)
    end
  
    def name; nil end
    
    def generator(format=:html)
      {:html=>PivotalDoc::Generators::Sprint}[format]
    end
    
    private
    def filter_stories(type='feature')
      self.iteration.stories.reject {|s| s.story_type.downcase != type }
    end
  end
end
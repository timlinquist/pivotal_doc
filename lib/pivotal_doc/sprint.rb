module PivotalDoc
  class Sprint
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
  end
end
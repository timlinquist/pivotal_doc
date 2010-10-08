module PivotalDoc
  class Release
    attr_reader :project
    attr_reader :iteration
  
    def initialize(project, iteration=nil)
      @project= project
      @iteration= (iteration || latest_iteration)
    end
    
    def name
      self.object_id.to_s
    end
  
    def project_name
      @project.name
    end
  
    def latest_iteration
      PT::Iteration.done(@project, :offset=>'-1').first
    end  
    
    def stories_delivered; stories.size end
    def bugs_delivered; bugs.size end
    def chores_delivered; chores.size end

    def stories
      @stories ||= self.iteration.stories
    end
  
    def bugs
      @bugs ||= self.stories.reject{|s| s.story_type.downcase != 'bug'}
    end
  
    def chores
      @chores ||= self.stories.reject{|s| s.story_type.downcase != 'chore'}
    end
  end
end
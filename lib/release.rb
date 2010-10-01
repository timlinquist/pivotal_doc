module PivotalDoc
  class Release
    attr_accessor :project
    attr_reader :iteration
  
    def initialize(project, iteration=nil)
      @project= project
      @iteration= iteration || latest_iteration
    end
  
    def latest_iteration
      PivotalTracker::Iteration.done(@project, :offset=>'-1')
    end  

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
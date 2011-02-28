module PivotalDoc
  module Work
    def project_name
      @project.name
    end
    
    def features
      self.stories + self.bugs + self.chores
    end     
    
    def stories
      @stories ||= filter_stories
    end

    def bugs
      @bugs ||= filter_stories('bug')
    end

    def chores
      @chores ||= filter_stories('chore')
    end
  end
end

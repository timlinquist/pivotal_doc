module PivotalDoc
  class Sprint    
    attr_reader :project, :iteration
  
    def initialize(project, current=false)
      @project= project
      @current= current
      @iteration= (@current) ? current_iteration : latest_iteration
    end
    
    def current?
      @current
    end
    
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
    
    def release
      @release ||= self.iteration.stories.detect{|s| s.story_type.downcase=='release'} if self.iteration.stories
    end
    
    def release_name
      release.name if release.respond_to?(:name) 
    end
    
    def latest_iteration
      PT::Iteration.done(@project, :offset=>'-1').first
    end
    
    def current_iteration
      PT::Iteration.current(@project)
    end
        
    [:stories, :bugs, :chores].each do |m|
      define_method("#{m}_delivered") { self.send(m).size }
    end
        
    private
    def filter_stories(type='feature')
      self.iteration.stories.reject do |s|
        s.story_type.downcase != type || s.current_state.downcase != 'accepted'
      end
    end
  end
end
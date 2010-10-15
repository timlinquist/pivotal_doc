module PivotalDoc
  class Release
    attr_reader :project
    attr_reader :iteration
  
    def initialize(project, iteration=nil)
      @project= project
      @iteration= (iteration || latest_iteration)
    end
    
    def me
      @me ||= self.iteration.stories.detect{|s| s.story_type.downcase=='release'} if self.iteration.stories
    end
    
    def name
      me.name if me.respond_to?(:name) 
    end
  
    def project_name
      @project.name
    end
  
    def latest_iteration
      PT::Iteration.done(@project, :offset=>'-1').first
    end     
    
    def stories
      @stories ||= self.iteration.stories.reject do |s|
        s.story_type.downcase != 'feature' || s.current_state.downcase != 'delivered'
      end
    end
  
    def bugs
      @bugs ||= self.iteration.stories.reject do |s|
        s.story_type.downcase != 'bug' || s.current_state.downcase != 'delivered'
      end
    end
  
    def chores
      @chores ||=  self.iteration.stories.reject do |s|
        s.story_type.downcase != 'chore' || s.current_state != 'accepted'
      end
    end
    
    [:stories, :bugs, :chores].each do |m|
      define_method("#{m}_delivered") { self.send(m).size }
    end    
  end
end
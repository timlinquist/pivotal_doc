module PivotalDoc
  class Release
    include Work
    
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
    
    def latest_iteration
      PT::Iteration.done(@project, :offset=>'-1').first
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
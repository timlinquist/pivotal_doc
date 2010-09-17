class Release
  attr_accessor :project, :iteration
  
  def initialize(iteration=nil)
    @iteration= iteration
  end
  
  def latest_iteration
    PivotalTracker::Iteration.done(@project, :offset=>'-1')
  end  

  def iteration
    @iteration ||= latest_iteration
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
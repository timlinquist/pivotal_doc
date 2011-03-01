module MocksHelper
  def mocks_helper(mock)
    raise "No mock exists yet for #{mock}!" unless mocks.has_key?(mock)
    return mocks[mock]
  end

  private  
  def sprint
    PT::Iteration.stub!(:current).and_return(iteration)
    sprint= PivotalDoc::Sprint.new(project, iteration)
    sprint.stub!(:stories).and_return(PTApiHelpers::mock_stories)
    sprint.stub!(:bugs).and_return(PTApiHelpers::mock_bugs)
    sprint.stub!(:chores).and_return(PTApiHelpers::mock_chores)
    sprint
  end
  
  def project
    return PTApiHelpers::mock_projects.first
  end
  
  def iteration
    return PTApiHelpers::mock_iterations.first
  end
  
  def mocks
    @@mocks= {
      :sprint=>sprint,
      :project=>project,
      :iteration=>iteration
    }
  end  
end
module MocksHelper
  def mocks_helper(mock)
    raise "No mock exists yet for #{mock}!" unless mocks.has_key?(mock)
    return mocks[mock]
  end

  private  
  def release
    release= PivotalDoc::Release.new(project, iteration)
    release.stub!(:stories).and_return(PTApiHelpers::mock_stories)
    release.stub!(:bugs).and_return(PTApiHelpers::mock_bugs)
    release.stub!(:chores).and_return(PTApiHelpers::mock_chores)
    release
  end
  
  def project
    return PTApiHelpers::mock_projects.first
  end
  
  def iteration
    return PTApiHelpers::mock_iterations.first
  end
  
  def mocks
    @@mocks= {
      :release=>release,
      :project=>project,
      :iteration=>iteration
    }
  end  
end
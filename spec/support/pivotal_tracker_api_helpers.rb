module PivotalTrackerApiHelpers
  FIXTURE_PATH= File.join(File.dirname(__FILE__), '/../fixtures/')

  def mock_object(file_name, attrs={})
    collection= mock_collection(file_name)
    collection.first.merge(attrs)
  end
  
  def mock_collection(file_name)
    fixture= File.new(File.join(FIXTURE_PATH, "#{file_name}.yml"))
    return YAML::load(fixture)    
  end
  
  def mock_stories
    @stories= mock_collection('stories').collect{|s| PivotalTracker::Story.new(s) }
  end

  def mock_projects
    @projects= mock_collection('projects').collect{|s| PivotalTracker::Story.new(s) }
  end
end
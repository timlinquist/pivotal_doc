module PivotalTrackerApiHelpers
  FIXTURE_PATH= File.join(File.dirname(__FILE__), '/../fixtures/')

  def parse_object(file_name)
    collection= parse_collection(file_name)
    collection.first
  end
  
  def parse_collection(file_name)
    fixture= File.new(File.join(FIXTURE_PATH, "#{file_name}.yml"))
    return YAML::load(fixture)    
  end
  
  def mock_stories
    @stories= parse_collection('stories').collect{|s| PivotalTracker::Story.new(s) }
  end

  def mock_projects
    @projects= parse_collection('projects').collect{|s| PivotalTracker::Story.new(s) }
  end
end
module PTApiHelpers
  FIXTURE_PATH= File.join(File.dirname(__FILE__), '/../fixtures/')

  def self.mock_object(file_name, attrs={})
    collection= mock_collection(file_name)
    collection.first.merge(attrs)
  end
  
  def self.mock_collection(file_name)
    fixture= File.new(File.join(FIXTURE_PATH, "#{file_name}.yml"))
    return YAML::load(fixture)    
  end
  
  def self.mock_stories
    mock_collection('stories').collect{|s| PT::Story.new(s) }
  end
  
  def self.mock_iterations
    mock_collection('iterations').collect{|iteration| set_attributes(PT::Iteration.new, iteration) }
  end
  
  def self.mock_actual_release
    mock_stories.detect{|s| s.story_type.downcase == 'release' }    
  end
  
  def self.mock_bugs
    mock_stories.reject{|s| s.story_type.downcase != 'bug' }
  end
  
  def self.mock_chores
    mock_stories.reject{|s| s.story_type.downcase != 'chores' }
  end

  def self.mock_projects
    mock_collection('projects').collect{|project| set_attributes(PT::Project.new, project) }
  end
  
  def self.set_attributes(obj, attrs={})
    attrs.each{|k,v| obj.send("#{k}=".to_sym, v)}    
    obj
  end
end
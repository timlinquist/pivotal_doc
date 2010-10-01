require File.dirname(__FILE__) + '/../spec_helper'

describe PivotalDoc::Generator do
  before(:each) do
    @iteration= mock_object('iterations')
    @project, @release= mock('PivotalDoc::Project.new'), PivotalDoc::Release.new(@project, @iteration)
    PivotalDoc::Release.stub!(:new).and_return(@release)
    PivotalTracker::Project.stub!(:find).and_return(@project)
    @release.stub!(:iteration).and_return(@iteration)
  end
  
  it "should connect to pivotal" do
    PivotalDoc::Generator.stub!(:collect_items).and_return({})
    PivotalDoc::Generator.generate
    PivotalDoc::Configuration.authenticated?.should be_true
  end
  
  describe "Projects" do        
    before(:each) do
      PivotalDoc::Configuration.configs=nil
      PivotalDoc::Configuration.stub!(:filepath).and_return(File.join(File.dirname(__FILE__), '/../fixtures/', 'configs.yml'))
      @items={:stories=>[mock('Story')], :bugs=>[mock('Chore')], :chores => [mock('Bug1'), mock('Bug2')] }
    end
    it "should group the stories for the latest iteration by type" do
      @items.keys.each{|k| @release.should_receive(k).at_least(:once).and_return(@items[k]) }
      items= PivotalDoc::Generator.collect_items
      project_items= items.fetch(items.keys.last)
      project_items.each {|k,v| project_items[k].should eql(@release.send(k)) }
    end
  end
  
  describe "Formattting" do
    it "should use the formatter specified in the configuration" do
      
    end
    
    it "should render the groups of stories through the formatter" do
      
    end
  end
end
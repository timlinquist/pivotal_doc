require File.dirname(__FILE__) + '/../spec_helper'

describe PivotalDoc::Generator do
  before(:each) do
    PivotalDoc::Generator.generators.each do |g| 
      generator= mock(g.to_s)
      g.stub!(:new).and_return(generator)
      generator.stub!(:render_notes)
    end
  end
  
  it "should connect to pivotal" do
    PivotalDoc::Generator.stub!(:collect_items).and_return({})
    PivotalDoc::Generator.generate
    PivotalDoc::Configuration.authenticated?.should be_true
  end

  describe "generation" do
    before(:each) do
      PivotalDoc::Configuration.stub!(:authenticate!).and_return(true)
      @iteration= mock_object('iterations')
      @project, @release= mock('PivotalDoc::Project.new'), PivotalDoc::Release.new(@project, @iteration)
      PivotalDoc::Release.stub!(:new).and_return(@release)
      PivotalTracker::Project.stub!(:find).and_return(@project)
      @release.stub!(:iteration).and_return(@iteration)
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
      before(:each) do
        PivotalDoc::Generator.stub!(:collect_items).and_return(@items)
        @html_gen= PivotalDoc::Generators::HTML.new({})
      end
      it "should render the items with the specified format" do
        PivotalDoc::Generators::HTML.should_receive(:new).with(@items).and_return(@html_gen)
        PivotalDoc::Generator.generate(:html)
      end
    end
  end
end
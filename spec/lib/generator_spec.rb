require File.dirname(__FILE__) + '/../spec_helper'

describe PivotalDoc::Generator do
  before(:each) do
    PivotalDoc::Generator.generators.values.each do |g| 
      generator= mock(g.to_s)
      g.stub!(:new).and_return(generator)
      generator.stub!(:render_doc)
    end
  end
  
  it "should authenticate against pivotal before generating the release docs" do
    PivotalDoc::Generator.stub!(:collect_items).and_return({})
    PivotalDoc::Configuration.should_receive(:authenticate!)
    PivotalDoc::Generator.generate
  end

  describe "generation" do
    before(:each) do
      PivotalDoc::Configuration.stub!(:authenticate!).and_return(true)
      @iteration= mock_object('iterations')
      @project, @release= mock('PivotalDoc::Project.new'), PivotalDoc::Release.new(@project, @iteration)
      PivotalDoc::Release.stub!(:new).and_return(@release)
      PivotalTracker::Project.stub!(:find).and_return(@project)
      @release.stub!(:iteration).and_return(@iteration)
      @name= 'github'
      @items={@name=>{:stories=>[mock('Story')], :bugs=>[mock('Chore')], :chores => [mock('Bug1'), mock('Bug2')]} }
    end

    describe "Projects" do        
      before(:each) do
        PivotalDoc::Configuration.configs=nil
        PivotalDoc::Configuration.stub!(:filepath).and_return(File.join(File.dirname(__FILE__), '/../fixtures/', 'configs.yml'))
      end
      it "should group the stories for the latest iteration by type" do
        @items[@name].keys.each{|k| @release.should_receive(k).at_least(:once).and_return(@items[@name][k]) }
        items= PivotalDoc::Generator.collect_items
        project_items= items.fetch(items.keys.last)
        project_items.each {|k,v| project_items[k].should eql(@release.send(k)) }
      end
    end

    describe "Formattting" do
      before(:each) do
        PivotalDoc::Generator.stub!(:collect_items).and_return(@items)
        @options={:my_custom_option=>'my custom value'}
        @html_gen= PivotalDoc::Generators::HTML.new({})
        @html_gen.stub!(:render_doc)
      end
      it "should render the items with the specified format and custom options" do
        PivotalDoc::Generators::HTML.should_receive(:new).with(@items[@name], @options).and_return(@html_gen)
        PivotalDoc::Generator.generate(:html, @options)
      end
      it "should raise an error if the specified format isn't supported" do
        lambda{ PivotalDoc::Generator.generate(:unsupported) }.should raise_error(PivotalDoc::FormatNotSupported)        
      end
    end
  end
end
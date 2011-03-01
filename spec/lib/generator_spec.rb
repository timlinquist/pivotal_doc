require 'spec_helper'

describe PivotalDoc::Generator do
  before(:each) do
    @config= PivotalDoc::Configuration.new(File.join(File.dirname(__FILE__), '/../fixtures/', 'configs.yml'))
    PivotalDoc::Configuration.stub!(:new).and_return(@config)
    PivotalDoc::Generator.generators.values.each do |g| 
      generator= mock(g.to_s)
      g.stub!(:new).and_return(generator)
      generator.stub!(:render_doc)
    end
  end
  
  describe "Configuring" do
    before(:each) do
      PivotalDoc::Generator.stub!(:collect_sprints!).and_return([])
    end
    it "should create a config object from the settings" do
      settings= {}
      PivotalDoc::Configuration.should_receive(:new).with(settings).and_return(@config)
      @config.stub!(:authenticate!)
      PivotalDoc::Generator.generate(:html, settings)
    end

    it "should authenticate against pivotal before generating the release docs" do
      @config.should_receive(:authenticate!)
      PivotalDoc::Generator.generate(:html)
    end    
  end
  
  describe "sprints" do
    before(:each) do
      @sprint= mocks_helper(:sprint)
      PivotalDoc::Sprint.stub!(:new).and_return(@sprint)
    end
    
    it "should create a sprint for each project" do
      PT::Iteration.stub!(:current).and_return(mocks_helper(:iteration))
      @config.projects.each do |name, settings| 
        PT::Project.should_receive(:find).with(settings['id'].to_i).and_return(@sprint.project) 
      end
      sprints= PivotalDoc::Generator.collect_sprints!(@config)
      sprints.size.should eql(@config.projects.size)
    end
  end

  describe "generation" do
    before(:each) do
      @config.stub!(:authenticate!).and_return(true)
      @sprint = mocks_helper(:sprint)
      PT::Project.stub!(:find).and_return(@sprint.project)
      PivotalDoc::Sprint.stub!(:new).and_return(@sprint)
    end

    describe "Formattting" do
      before(:each) do
        @options={:my_custom_option=>'my custom value'}
        @html_gen= PivotalDoc::Generators::HTML.new({})
        @html_gen.stub!(:render_doc)
      end

      it "should render the release with the specified format and custom settings" do
        PivotalDoc::Generators::HTML.should_receive(:new).with(@sprint, @config.settings).and_return(@html_gen)
        PivotalDoc::Generator.generate(:html)
      end
      it "should raise an error if the specified format isn't supported" do
        lambda{ PivotalDoc::Generator.generate(:unsupported) }.should raise_error(PivotalDoc::FormatNotSupported)        
      end
    end
  end
end
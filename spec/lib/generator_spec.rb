require File.dirname(__FILE__) + '/../spec_helper'

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
      PivotalDoc::Generator.stub!(:collect_releases!)
      PivotalDoc::Generator.releases= []
    end

    it "should create a config object from the settings" do
      settings= {}
      @config.stub!(:authenticate!)
      PivotalDoc::Configuration.should_receive(:new).with(settings).and_return(@config)
      PivotalDoc::Generator.generate(:html, settings)
      PivotalDoc::Generator.config.should eql(@config)
    end

    it "should authenticate against pivotal before generating the release docs" do
      @config.should_receive(:authenticate!)
      PivotalDoc::Generator.generate(:html)
    end
  end

  describe "generation" do
    before(:each) do
      @config.stub!(:authenticate!).and_return(true)
      @release= mocks_helper(:release)
      PT::Project.stub!(:find).and_return(@release.project)
      PivotalDoc::Release.stub!(:new).and_return(@release)
    end

    describe "Formattting" do
      before(:each) do
        @options={:my_custom_option=>'my custom value'}
        @html_gen= PivotalDoc::Generators::HTML.new({})
        @html_gen.stub!(:render_doc)
      end
      it "should render the release with the specified format and custom options" do
        PivotalDoc::Generators::HTML.should_receive(:new).with(@release, @options).and_return(@html_gen)
        PivotalDoc::Generator.generate(:html, nil, @options)
      end
      it "should raise an error if the specified format isn't supported" do
        lambda{ PivotalDoc::Generator.generate(:unsupported) }.should raise_error(PivotalDoc::FormatNotSupported)        
      end
    end
  end
end
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
    PivotalDoc::Generator.stub!(:collect_releases!)
    PivotalDoc::Generator.releases= []
    PivotalDoc::Configuration.should_receive(:authenticate!)
    PivotalDoc::Generator.generate
  end

  describe "generation" do
    before(:each) do
      PivotalDoc::Configuration.stub!(:authenticate!).and_return(true)
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
        PivotalDoc::Generator.generate(:html, @options)
      end
      it "should raise an error if the specified format isn't supported" do
        lambda{ PivotalDoc::Generator.generate(:unsupported) }.should raise_error(PivotalDoc::FormatNotSupported)        
      end
    end
  end
end
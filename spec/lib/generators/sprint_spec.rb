require 'spec_helper'

describe PivotalDoc::Generators::Sprint do
  before(:each) do
    @release= mocks_helper(:release)
    @sprint= PivotalDoc::Generators::Sprint.new(@release)
    @engine= Haml::Engine.new('')
  end
  
  after(:each) do
    File.delete(@sprint.output_file) if File.exists?(@sprint.output_file)
  end
  
  it "should open the output file and write the compiled haml (html)" do
    Haml::Engine.stub!(:new).and_return(@engine)
    @engine.stub!(:render).and_return('compiled haml')
    @sprint.render_doc
    File.read(@sprint.output_file).should eql('compiled haml')
  end
  
  it "should read the file contents" do
    @sprint.template.should be_an_instance_of(String)
  end
  
  it "should use the template_name if specified" do
    options= {'template_name'=>'fancy.sprint.html'}
    html= PivotalDoc::Generators::HTML.new(@release, options)
    html.template_name.should eql(options['template_name'])
  end
  
  it "should know its template name" do
    @sprint.template_name.should =~ /\.haml$/
  end
  
  it "should render the release doc" do
    Haml::Engine.should_receive(:new).with(@sprint.template).and_return(@engine)
    @engine.should_receive(:render)
    @sprint.render_doc
  end
end
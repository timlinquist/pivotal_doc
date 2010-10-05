require File.dirname(__FILE__) + '/../../spec_helper'

describe PivotalDoc::Generators::HTML do
  before(:each) do
    @html= PivotalDoc::Generators::HTML.new({})
    @engine= Haml::Engine.new('')
  end
  
  after(:each) do
    File.delete(@html.output_file) if File.exists?(@html.output_file)
  end
  
  it "should open the output file and write the compiled haml (html)" do
    Haml::Engine.stub!(:new).and_return(@engine)
    @engine.stub!(:render).and_return('compiled haml')
    @html.render_doc
    File.read(@html.output_file).should eql('compiled haml')
  end
  
  it "should read the file contents" do
    @html.template.should be_an_instance_of(String)
  end
  
  it "should know its tempalte name" do
    @html.template_name.should =~ /\.haml$/
  end
  
  it "should render the release doc" do
    Haml::Engine.should_receive(:new).with(@html.template).and_return(@engine)
    @engine.should_receive(:render)
    @html.render_doc
  end
end
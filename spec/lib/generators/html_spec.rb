require File.dirname(__FILE__) + '/../../spec_helper'

describe PivotalDoc::Generators::HTML do
  before(:each) do
    @html= PivotalDoc::Generators::HTML.new({})
  end
  it "should read the file contents" do
    @html.template.should be_an_instance_of(String)
  end
  
  it "should know its tempalte name" do
    @html.template_name.should =~ /\.haml$/
  end
end
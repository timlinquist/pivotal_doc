require File.dirname(__FILE__) + '/../../spec_helper'

describe PivotalDoc::Generators::Text do
  before(:each) do
    @text= PivotalDoc::Generators::Text.new(mocks_helper(:release))
  end
  
  after(:each) do
    File.delete(@text.output_file) if File.exists?(@text.output_file)
  end
  
  it "should render the text and write to the output file" do
    @text.should_receive(:output).and_return('my_text')
    @text.render_doc
    File.read(@text.output_file).should eql('my_text')
  end
  
  it "should read the file contents" do
    @text.template.should be_an_instance_of(String)
  end
  
  it "should know its tempalte name" do
    @text.template_name.should =~ /\.txt$/
  end
end
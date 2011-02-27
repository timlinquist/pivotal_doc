require File.dirname(__FILE__) + '/../../spec_helper'

describe PivotalDoc::Generators::CSV do
  before(:each) do
    @release= mocks_helper(:release)
    @csv= PivotalDoc::Generators::CSV.new(@release)
  end
  
  after(:each) do
    File.delete(@csv.output_file) if File.exists?(@csv.output_file)
  end
  
  describe "Generating CSV" do
    before(:each) do
      pending 'Need to verify csv output'      
    end

    it "should open the output file and write the csv" do
      @csv.render_doc
      File.read(@csv.output_file).should eql('compiled haml')
    end

    it "should read the file contents" do
      @csv.template.should be_an_instance_of(String)
    end

    it "should know its template name" do
      @csv.template_name.should =~ /\.csv$/
    end    
  end
end
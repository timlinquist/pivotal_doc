require File.dirname(__FILE__) + '/../../spec_helper'

describe PivotalDoc::Generators::CSV do
  before(:each) do
    @sprint= mocks_helper(:sprint)
    @csv= PivotalDoc::Generators::CSV.new(@sprint)
  end
  
  after(:each) do
    File.delete(@csv.output_file) if File.exists?(@csv.output_file)
  end
  
  describe "Generating CSV" do
    it "should open the output file and write the csv with columns" do
      @csv.render_doc
      output= File.read(@csv.output_file)
      output.should =~ /#{PivotalDoc::Generators::CSV::COLUMNS.join(',')}/
      @sprint.features.each{|f| output =~ @csv.fields(f) }
    end

    it "should read the file contents" do
      @csv.template.should be_an_instance_of(String)
    end

    it "should know its template name" do
      @csv.template_name.should =~ /\.csv$/
    end 
    
    it "include each field" do
      fields= @csv.fields(@sprint.features.first)
      fields.should be_an_instance_of(Array)
      fields.should have(PivotalDoc::Generators::CSV::COLUMNS.size).items
    end   
  end
end
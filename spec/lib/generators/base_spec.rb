require File.dirname(__FILE__) + '/../../spec_helper'

describe PivotalDoc::Generators::Base do
  describe "Rendering the doc" do
    before(:each) do
      @items= {:stories=>[],:chores=>[],:bugs=>[]}
      @base= PivotalDoc::Generators::Base.new(@items)
      @base.stub!(:template).and_return('index.txt')
      @engine= Haml::Engine.new('')
    end
    
    it "should render the release doc" do
      Haml::Engine.should_receive(:new).with(@base.template).and_return(@engine)
      @engine.should_receive(:render)
      @base.render_doc
    end
    
    it "should open the output file and write the compiled haml (html)" 
    it "should handle any exceptions and output STDOUT" 
  end
end
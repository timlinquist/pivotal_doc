require File.dirname(__FILE__) + '/../../spec_helper'

describe PivotalDoc::Generators::Base do
  describe "Rendering the doc" do
    before(:each) do
      @items= {:stories=>[],:chores=>[],:bugs=>[]}
      @base= PivotalDoc::Generators::Base.new(@items)
      @base.stub!(:template).and_return('index.txt')
    end
    
    it "should render the release doc" do
      Haml::Engine.should_receive(:new).with(@base.template, {:local_assigns => {:items => @items}})
      @base.render_doc
    end
  end
end
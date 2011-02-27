require 'spec_helper'

describe PivotalDoc::LabelFilter do
  before(:each) do
    @project, @label = mocks_helper(:project), 'incomplete'
    @filter= PivotalDoc::LabelFilter.new(@project, @label)
  end
  it "have a project" do
    @filter.project.should eql(@project)
  end
  
  it "have a label" do
    @filter.label.should eql(@label)
  end
  
  it "find all the stories for the label" do
    PT::Story.should_receive(:all).with(@project,  {:label=>@label})
    @filter.stories
  end
end
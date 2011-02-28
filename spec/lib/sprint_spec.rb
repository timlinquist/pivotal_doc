require 'spec_helper'

describe PivotalDoc::Sprint do
  before(:each) do
    @project= PT::Project.new
    @iteration= PT::Iteration.new
    PT::Iteration.stub!(:current).and_return([@iteration])
    @sprint= PivotalDoc::Sprint.new(@project)
  end
  
  it "not have a release name" do
    @sprint.name.should be_nil
  end
  
  it "know the html generator" do
    @sprint.generator(:html).should eql(PivotalDoc::Generators::Sprint)
  end
  
  it "only know the html generator" do
    @sprint.generator(:unknown).should be_nil    
  end
end
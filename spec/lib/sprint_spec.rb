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

  describe "stories" do
    before(:each) do
      @stories= PTApiHelpers::mock_stories
      @sprint.iteration.stub!(:stories).and_return(@stories)
    end

    it "should get the stories only" do
      @sprint.iteration.should_receive(:stories).and_return(@stories)
      @sprint.stories.each{|s| s.story_type.downcase.should eql('feature') }
    end

    it "should get the bugs only" do
      @sprint.iteration.should_receive(:stories).and_return(@stories)
      @sprint.bugs.each{|b| b.story_type.downcase.should eql('bug') }
    end

    it "should get the chores only" do
      @sprint.iteration.should_receive(:stories).and_return(@stories)
      @sprint.chores.each{|c| c.story_type.downcase.should eql('chore') }
    end
  end
end

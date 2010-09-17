require File.dirname(__FILE__) + '/../spec_helper'

describe Release do
  before(:each) do
    @project= PivotalTracker::Project.new
    @latest_iteration= PivotalTracker::Iteration.new
    @release= Release.new
  end

  it "should get the last 'done' iteration for the project" do
    PivotalTracker::Iteration.should_receive(:done).with(@project, :offset=>'-1')
    @release.project= @project
    @release.latest_iteration
  end
  
  describe "the current iteration" do
    before(:each) do
      @release.stub!(:latest_iteration).and_return(@latest_iteration)
    end
    
    it "should default the iteration to the latest_iteration" do
      @release.should_receive(:latest_iteration).and_return(@latest_iteration)
      @release.iteration.should eql(@latest_iteration)
    end

    it "should use the iteration if set" do
      @release.iteration= mock('PivotalTracker::Iteration')
      @release.should_not_receive(:latest_iteration)
      @release.iteration
    end

    describe "latest" do
      it "should get the stories" do
        stories= []
        @latest_iteration.should_receive(:stories).and_return(stories)
        @release.stories.should eql(stories)
      end

      it "should get the bugs only" do
        mock_stories
        @latest_iteration.stub!(:stories).and_return(@stories)
        @release.bugs.each{|b| b.story_type.downcase.should eql('bug') }
      end
      
      it "should get the chores only" do
        mock_stories
        @latest_iteration.stub!(:stories).and_return(@stories)
        @release.chores.each{|b| b.story_type.downcase.should eql('chore') }        
      end
    end
  end  
end

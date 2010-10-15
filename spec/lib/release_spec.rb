require File.dirname(__FILE__) + '/../spec_helper'

describe PivotalDoc::Release do
  before(:each) do
    @project= PT::Project.new
    @latest_iteration= PT::Iteration.new
    PT::Iteration.stub!(:done).and_return([@latest_iteration])
    @release= PivotalDoc::Release.new(@project)
  end

  it "should get the last 'done' iteration for the project" do
    PT::Iteration.should_receive(:done).with(@project, :offset=>'-1')
    @release.latest_iteration
  end
  
  describe "the latest iteration" do
    before(:each) do
      @release.stub!(:latest_iteration).and_return(@latest_iteration)
    end
    
    it "should use the iteration if specified" do
      backlog= PTApiHelpers::mock_object('iterations')
      release= PivotalDoc::Release.new(@project, backlog)
      release.iteration.should eql(backlog)      
    end
    
    it "should default the iteration to the latest_iteration (last 'done') if one isn't specified" do
      PT::Iteration.should_receive(:done).and_return([@latest_iteration])
      release= PivotalDoc::Release.new(@project)
      release.iteration.should eql(@latest_iteration)
    end
    
    describe "release of (me)" do
      before(:each) do
        @stories= PTApiHelpers::mock_stories
        @me= PTApiHelpers::mock_actual_release
        @latest_iteration.stub!(:stories).and_return(@stories)
      end
      
      it "should find the \"release\" if there is one" do
        @latest_iteration.should_receive(:stories).and_return(@stories)
        @release.me.story_type.should eql('release')
      end
      
      it "should know the name of the release" do
        @release.name.should eql(@me.name)
      end
    end

    describe "stories" do
      before(:each) do
        @stories= PTApiHelpers::mock_stories
        @latest_iteration.stub!(:stories).and_return(@stories)
      end
      
      it "should get the stories only" do
        @latest_iteration.should_receive(:stories).and_return(@stories)
        @release.stories.each{|s| s.story_type.downcase.should eql('feature') }
      end

      it "should get the bugs only" do
        @latest_iteration.should_receive(:stories).and_return(@stories)
        @release.bugs.each{|b| b.story_type.downcase.should eql('bug') }
      end
      
      it "should get the chores only" do
        @latest_iteration.should_receive(:stories).and_return(@stories)
        @release.chores.each{|c| c.story_type.downcase.should eql('chore') }        
      end

      describe "finished work" do
        [:stories, :chores, :bugs].each do |m|
          it "should know the #{m} delivered in this release" do
            @release.send("#{m}_delivered").should eql(@release.send(m).size)
          end
        end
        
        it "should only get the \"delivered\" stories" do
          @release.stories.each{|s| s.current_state.downcase.should eql('accepted')}
        end

        it "should only get the \"delivered\" bugs" do
          @release.bugs.each{|b| b.current_state.downcase.should eql('accepted')}
        end

        it "should only get the \"accepted\" chores" do
          @release.chores.each{|c| c.current_state.downcase.should eql('accepted')}
        end
      end      
    end
  end  
end

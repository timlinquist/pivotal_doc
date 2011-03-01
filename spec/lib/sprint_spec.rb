require 'spec_helper'

describe PivotalDoc::Sprint do
  before(:each) do
    @project= PT::Project.new
    @latest_iteration, @current_iteration = PT::Iteration.new, PT::Iteration.new
    PT::Iteration.stub!(:done).and_return([@latest_iteration])
    @sprint= PivotalDoc::Sprint.new(@project)
  end

  it "should get the last 'done' iteration for the project" do
    PT::Iteration.should_receive(:done).with(@project, :offset=>'-1').and_return([@latest_iteration])
    @sprint.latest_iteration.should eql(@latest_iteration)
  end

  it "should get the current iteration for the project" do
    PT::Iteration.should_receive(:current).and_return(@current_iteration)
    @sprint.current_iteration.should eql(@current_iteration)
  end
  
  describe "an iteration" do
    before(:each) do
      @sprint.stub!(:latest_iteration).and_return(@latest_iteration)
    end
        
    it "should default the iteration to the latest_iteration (last 'done') if current isn't set" do
      PT::Iteration.should_receive(:done).and_return([@latest_iteration])
      sprint= PivotalDoc::Sprint.new(@project)
      sprint.iteration.should eql(@latest_iteration)
    end
    
    describe "release of sprint" do
      before(:each) do
        @stories= PTApiHelpers::mock_stories
        @release= PTApiHelpers::mock_actual_release
        @latest_iteration.stub!(:stories).and_return(@stories)
      end
      
      it "should find the \"release\" if there is one" do
        @latest_iteration.should_receive(:stories).and_return(@stories)
        @sprint.release.story_type.should eql('release')
      end
      
      it "should know the name of the release" do
        @sprint.release_name.should eql(@release.name)
      end
    end

    describe "stories" do
      before(:each) do
        @stories= PTApiHelpers::mock_stories
        @latest_iteration.stub!(:stories).and_return(@stories)
      end
      
      it "should get the stories only" do
        @latest_iteration.should_receive(:stories).and_return(@stories)
        @sprint.stories.each{|s| s.story_type.downcase.should eql('feature') }
      end

      it "should get the bugs only" do
        @latest_iteration.should_receive(:stories).and_return(@stories)
        @sprint.bugs.each{|b| b.story_type.downcase.should eql('bug') }
      end
      
      it "should get the chores only" do
        @latest_iteration.should_receive(:stories).and_return(@stories)
        @sprint.chores.each{|c| c.story_type.downcase.should eql('chore') }        
      end

      describe "finished work" do
        [:stories, :chores, :bugs].each do |m|
          it "should know the #{m} delivered in this release" do
            @sprint.send("#{m}_delivered").should eql(@sprint.send(m).size)
          end
        end
        
        it "should only get the \"delivered\" stories" do
          @sprint.stories.each{|s| s.current_state.downcase.should eql('accepted')}
        end

        it "should only get the \"delivered\" bugs" do
          @sprint.bugs.each{|b| b.current_state.downcase.should eql('accepted')}
        end

        it "should only get the \"accepted\" chores" do
          @sprint.chores.each{|c| c.current_state.downcase.should eql('accepted')}
        end
      end      
    end
  end  
end

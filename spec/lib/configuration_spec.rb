require File.dirname(__FILE__) + '/../spec_helper'

describe Configuration do
  it "should load the configs" do
    Configuration.configs.should be_an_instance_of(Hash)
  end

  describe "A Project" do
    before(:each) do
      @project= Configuration.configs.fetch(Configuration.configs.keys.first)
    end
    
    it "should know the members" do
      @project['members'].should be_an_instance_of(Array)
    end
    
    it "should know its id" do
      @project['id'].should be_an_instance_of(Fixnum)
    end
  end
end

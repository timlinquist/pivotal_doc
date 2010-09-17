require File.dirname(__FILE__) + '/../spec_helper'

describe Configuration do
  it "should load the configs" do
    Configuration.configs.should be_an_instance_of(Hash)
  end

  describe "A Project" do
    before(:each) do
      @projects= Configuration.configs['projects']
      @project= @projects.fetch(@projects.keys.first)
    end
    
    it "should know all of the projects" do
      @projects.should_not be_empty
    end
    
    it "should know the members" do
      @project['members'].should be_an_instance_of(Array)
    end
    
    it "should know its id" do
      @project['id'].should be_an_instance_of(Fixnum)
    end
  end
  
  describe "Connection" do
    after(:each) do
      Configuration.instance_variable_set(:@connection, nil)
    end
    
    [:token, :username, :password].each do |property|
      connection= Connection.new
      it "should have the #{property} property" do
        connection.should respond_to(property)
      end
    end

    it "should not redefine the connection" do
      Configuration.connection{|conn| conn.username='only_once@distinct.com'}
      Configuration.connection.username.should eql('only_once@distinct.com')
    end
    
    it "should be configurable" do
      token= '1aDs1a22'
      Configuration.connection{ |conn| conn.token = token }
      Configuration.connection.token.should eql(token)
    end
    
    it "should default to the config.yml settings" do
      Configuration.stub!(:filepath).and_return(File.dirname(__FILE__) + '/../fixtures/configs.yml')
      %w(token username password).each do |_attr|
        Configuration.connection.send(_attr.to_sym).should eql(Configuration.configs[_attr])  
      end
    end
  end
end

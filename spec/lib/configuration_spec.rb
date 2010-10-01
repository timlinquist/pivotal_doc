require File.dirname(__FILE__) + '/../spec_helper'

describe PivotalDoc::Configuration do
  before(:each) do
    @connection= PivotalDoc::Connection.new('A18das1', 'radical', 'dude')
  end

  it "should load the configs" do
    PivotalDoc::Configuration.configs.should be_an_instance_of(Hash)
  end

  describe "Authenticating" do
    before(:each) do
      PivotalDoc::Configuration.instance_variable_set(:@connection, @connection)
    end
    
    after(:each) do
      PivotalDoc::Configuration.instance_variable_set(:@authenticated, false)
    end
    
    it "should set the token if it's configured" do
      PivotalTracker::Client.should_receive(:token=).with(@connection.token)
      PivotalDoc::Configuration.authenticate!
    end
    
    it "should set the token via the username & password if the token isn't configured" do
      @connection.token= nil
      PivotalTracker::Client.should_receive(:token).with(@connection.username, @connection.password)
      PivotalDoc::Configuration.authenticate!      
    end
    
    it "should not set the token again if the client is already authenticated" do
      PivotalTracker::Client.should_receive(:token=).exactly(:once)
      PivotalDoc::Configuration.authenticate!
      PivotalDoc::Configuration.authenticate!
    end
  end

  describe "A Project" do
    before(:each) do
      PivotalDoc::Configuration.configs=nil
      PivotalDoc::Configuration.stub!(:filepath).and_return(File.join(File.dirname(__FILE__), '/../fixtures/', 'configs.yml'))
      @projects= PivotalDoc::Configuration.projects
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
      PivotalDoc::Configuration.instance_variable_set(:@connection, nil)
    end
    
    [:token, :username, :password].each do |property|
      connection= PivotalDoc::Connection.new
      it "should have the #{property} property" do
        connection.should respond_to(property)
      end
    end

    it "should not redefine the connection" do
      PivotalDoc::Connection.should_receive(:new).exactly(:once).and_return(@connection)
      PivotalDoc::Configuration.send(:connection)
    end
    
    it "should default to the config.yml settings" do
      %w(token username password).each do |_attr|
        PivotalDoc::Configuration.send(:connection).send(_attr.to_sym).should eql(PivotalDoc::Configuration.configs[_attr])  
      end
    end
  end
end

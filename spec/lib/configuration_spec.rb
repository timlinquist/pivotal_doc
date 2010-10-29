require File.dirname(__FILE__) + '/../spec_helper'

describe PivotalDoc::Configuration do
  before(:each) do
    @connection= PivotalDoc::Connection.new('A18das1', 'radical', 'dude')
    @config= PivotalDoc::Configuration.new(File.join(File.dirname(__FILE__), '/../fixtures/', 'configs.yml'))
  end

  it "should load the settings from the file" do
    @config.settings.should be_an_instance_of(Hash)
  end
  
  it "should load the settings from the options" do
    settings= {:test=>'parameter'}
    config= PivotalDoc::Configuration.new(settings)
    config.settings.should eql(settings)
  end

  describe "Authenticating" do
    before(:each) do
      @config.instance_variable_set(:@connection, @connection)
    end
    
    after(:each) do
      @config.instance_variable_set(:@authenticated, false)
    end
    
    it "should set the token if it's configured" do
      PT::Client.should_receive(:token=).with(@connection.token)
      @config.authenticate!            
    end
    
    it "should set the token via the username & password if the token isn't configured" do
      @connection.token= nil
      PT::Client.should_receive(:token).with(@connection.username, @connection.password)
      @config.authenticate!      
    end
    
    it "should not set the token again if the client is already authenticated" do
      PT::Client.should_receive(:token=).exactly(:once)
      @config.authenticate!
      @config.authenticate!
    end
  end

  describe "A Project" do
    before(:each) do
      @projects= @config.projects
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
      @config.instance_variable_set(:@connection, nil)
    end
    
    [:token, :username, :password].each do |property|
      connection= PivotalDoc::Connection.new
      it "should have the #{property} property" do
        connection.should respond_to(property)
      end
    end

    it "should not redefine the connection" do
      PivotalDoc::Connection.should_receive(:new).exactly(:once).and_return(@connection)
      @config.send(:connection)
    end
    
    it "should default to the config.yml settings" do
      %w(token username password).each do |_attr|
        @config.send(:connection).send(_attr.to_sym).should eql(@config.settings[_attr])  
      end
    end
  end
end

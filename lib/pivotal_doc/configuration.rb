module PivotalDoc
  class Configuration
    attr_accessor :settings
    attr_reader :authenticated
    alias :authenticated? :authenticated

    def initialize(settings)
      @settings= settings.respond_to?(:merge) ? settings : YAML::load(File.new(settings))
    end
    
    def projects
      self.settings['projects']
    end
    
    def output_path
      self.settings['output_path']
    end
    
    def authenticate!
      return if @authenticated
      connection.token ? PT::Client.token=connection.token : PT::Client.token(connection.username, connection.password)
      @authenticated= true
    end

    private
    def connection
      return @connection if @connection
      @connection= Connection.new
      @connection.token= settings['token']
      @connection.username= settings['username']
      @connection.password= settings['password']
      @connection
    end
  end

  class Connection < Struct.new(:token, :username, :password); end
end

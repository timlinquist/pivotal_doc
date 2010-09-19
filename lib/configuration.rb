module PivotalDoc
  class Configuration
    class << self
      def filepath
        File.join(File.dirname(__FILE__), '/../configs.yml')
      end

      def configs
        @configs= YAML::load(File.new(filepath))
      end
      
      def authenticate!
        return if @authenticated
        connection.token ? PivotalTracker::Client.token= connection.token : PivotalTracker::Client.token(connection.username, connection.password)
        @authenticated= true
      end

      private
      def connection(&block)
        return @connection if @connection
        @connection= Connection.new
        @connection.token= configs['token']
        @connection.username= configs['username']
        @connection.password= configs['password']
        @connection
      end
    end
  end

  class Connection < Struct.new(:token, :username, :password); end
end

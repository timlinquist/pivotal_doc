module PivotalDoc
  class Configuration
    class << self
      attr_accessor :configs
      attr_reader :authenticated
      alias :authenticated? :authenticated

      def filepath
        File.join(File.dirname(__FILE__), '/../configs.yml')
      end

      def configs
        @configs ||= YAML::load(File.new(filepath))
      end
      
      def projects
        self.configs['projects']
      end
      
      def authenticate!
        return if @authenticated
        connection.token ? PivotalTracker::Client.token= connection.token : PivotalTracker::Client.token(connection.username, connection.password)
        @authenticated= true
      end

      private
      def connection
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

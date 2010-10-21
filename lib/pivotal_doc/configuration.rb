module PivotalDoc
  class Configuration
    class << self
      attr_accessor :configs
      attr_reader :authenticated
      alias :authenticated? :authenticated

      #Provide object access
      #Accept a file/options on initialize
      #Parse file if present
      #use options if present

      def filepath=(file)
        @filepath= file
      end
      
      def filepath
        PROJECT_ROOT + 'configs.yml'
      end

      def configs
        @configs ||= YAML::load(File.new(filepath))
      end
      
      def projects
        self.configs['projects']
      end
      
      def output_path
        self.configs['output_path']
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
        @connection.token= configs['token']
        @connection.username= configs['username']
        @connection.password= configs['password']
        @connection
      end
    end
  end

  class Connection < Struct.new(:token, :username, :password); end
end

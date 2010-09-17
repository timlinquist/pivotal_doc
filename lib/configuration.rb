class Configuration
  class << self
    def filepath
      File.join(File.dirname(__FILE__), '/../configs.yml')
    end
    
    def configs
      @configs= YAML::load(File.new(filepath))
    end

    def connection(&block)
      return @connection if @connection
      @connection= Connection.new
      if block_given?
        yield(@connection)
      else
        @connection.token= configs['token']
        @connection.username= configs['username']
        @connection.password= configs['password']
      end
      @connection
    end
  end
end

class Connection < Struct.new(:username, :password, :token); end

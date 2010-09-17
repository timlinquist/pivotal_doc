class Configuration
  class << self
    def configs
      @configs= YAML::load(File.new(File.join(File.dirname(__FILE__), '/../configs.yml')))
    end
  end
end
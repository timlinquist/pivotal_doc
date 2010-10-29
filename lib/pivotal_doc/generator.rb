module PivotalDoc
  class Generator    
    class << self
      attr_accessor :releases
      attr_reader :config
      
      def generate(format, settings={})
        @config= PivotalDoc::Configuration.new(settings)
        @config.authenticate!
        raise FormatNotSupported.new(format) unless generators.has_key?(format)
        collect_releases!
        releases.each do |release|          
          generators[format].new(release, config.settings).render_doc
        end
        true
      end
    
      def generators
        { :text=>Generators::Text, :html=>Generators::HTML }
      end
    
      def collect_releases!
        @releases= []
        self.config.projects.each do |name, _attrs|
          @releases << Release.new(PT::Project.find(_attrs['id'].to_i))
        end
      end
    end    
  end
end

module PivotalDoc
  class Generator    
    class << self
      def generate(format, settings={})
        config= PivotalDoc::Configuration.new(settings)
        config.authenticate!
        raise FormatNotSupported.new(format) unless generators.has_key?(format)
        releases= collect_releases!(config)
        releases.each do |release|          
          generators[format].new(release, config.settings).render_doc
        end
        true
      end      
    
      def generators
        { :text=>Generators::Text, :html=>Generators::HTML }
      end
    
      def collect_releases!(config)
        releases= []
        config.projects.each do |name, _attrs|
          project= PT::Project.find(_attrs['id'].to_i)
          iteration= PT::Iteration.current(project) if _attrs['current']
          releases << Release.new(project, iteration)
        end
        return releases
      end
    end    
  end
end

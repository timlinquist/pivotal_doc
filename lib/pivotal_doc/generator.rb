module PivotalDoc
  class Generator    
    class << self
      #TODO: Clean this mutatant up
      def generate(format, settings={})
        config= PivotalDoc::Configuration.new(settings)
        config.authenticate!
        raise FormatNotSupported.new(format) unless generators.has_key?(format)
        releases= collect_releases!(config)
        releases.each do |release|
          generator= release.generator(format) if release.respond_to?(:generator)
          (generator || generators[format]).new(release, config.settings).render_doc
        end
        true
      end      
    
      def generators
        { :text=>Generators::Text, :html=>Generators::HTML, :csv=>Generators::CSV }
      end
    
      def collect_releases!(config)
        releases= []
        config.projects.each do |name, _attrs|
          project= PT::Project.find(_attrs['id'].to_i)
          if _attrs['current']
            releases << Sprint.new(project)
          else
            releases << Release.new(project)
          end
        end
        return releases
      end
    end    
  end
end

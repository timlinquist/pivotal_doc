module PivotalDoc
  class Generator    
    class << self
      def generate(format, settings={})
        raise FormatNotSupported.new(format) unless generators.has_key?(format)
        config= PivotalDoc::Configuration.new(settings)
        config.authenticate!
        sprints= collect_sprints!(config)
        sprints.each do |sprint|
          generators[format].new(sprint, config.settings).render_doc
        end
        true
      end      
    
      def generators
        { :html=>Generators::HTML, :csv=>Generators::CSV }
      end
    
      def collect_sprints!(config)
        sprints= []
        config.projects.each do |name, _attrs|
          project= PT::Project.find(_attrs['id'].to_i)
          sprints << PivotalDoc::Sprint.new(project, _attrs['current'])
        end
        return sprints
      end
    end    
  end
end

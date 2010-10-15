module PivotalDoc
  class Generator    
    class << self
      attr_accessor :releases
      
      def generate(format= :html, options={})
        Configuration.authenticate!
        raise FormatNotSupported.new(format) unless generators.has_key?(format)
        collect_releases!
        releases.each do |release|          
          generators[format].new(release, options).render_doc
        end
        true
      end
    
      def generators
        { :text=>Generators::Text, :html=>Generators::HTML }
      end
    
      def collect_releases!
        @releases= []
        Configuration.projects.each do |name, _attrs|
          @releases << Release.new(PT::Project.find(_attrs['id'].to_i))
        end
      end
    end    
  end
end
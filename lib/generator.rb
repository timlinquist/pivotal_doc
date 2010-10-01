module PivotalDoc
  class Generator
    attr_accessor :release
    
    class << self
      def generate(format= :html)
        Configuration.authenticate!
        raise FormatNotSupported.new(format) unless generators.has_key?(format)
        generators[format].new(collect_items).render_doc
      end
    
      def generators
        { :text=>Generators::Text, :html=>Generators::HTML }
      end
    
      def collect_items
        items= {}
        Configuration.projects.each do |name, _attrs|
          id= _attrs['id']
          release= Release.new(PivotalTracker::Project.find(id))
          items[name]= {:stories=>release.stories, :bugs=>release.bugs, :chores=>release.chores}
        end
        items
      end
    end    
  end
end

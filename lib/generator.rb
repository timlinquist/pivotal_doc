module PivotalDoc
  class Generator
    attr_accessor :release
    
    class << self
      def generate(format= :html)
        Configuration.authenticate!
        generators[format].new(collect_items).render_notes
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

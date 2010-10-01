module PivotalDoc
  class Generator
    attr_accessor :release
    
    class << self
      def generate(format= :html)
        Configuration.authenticate!
        items= collect_items
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

module PivotalDoc
  class Generator
    attr_accessor :release
    
    class << self
      def generate(format= :html, options={})
        Configuration.authenticate!
        raise FormatNotSupported.new(format) unless generators.has_key?(format)
        items= collect_items
        Configuration.projects.keys.each do |name|          
          generators[format].new(items[name], options).render_doc
        end
      end
    
      def generators
        { :text=>Generators::Text, :html=>Generators::HTML }
      end
    
      def collect_items
        items= {}
        Configuration.projects.each do |name, _attrs|
          id= _attrs['id']
          release= Release.new(PivotalTracker::Project.find(id)) rescue nil
          items[name]= {:stories=>release.stories, :bugs=>release.bugs, :chores=>release.chores} if release
        end
        items
      end
    end    
  end
end

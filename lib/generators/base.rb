module PivotalDoc
  module Generators
    class Base
      def initialize(items)
        @items= items
      end
      
      def render_doc
        begin
          f= File.open('/Users/tim/Desktop/demo.html', 'w+')
          html= Haml::Engine.new(template).render(Object.new, {:items => @items})
          f.puts(html)
        rescue Exception=>e
          puts e.message
        ensure
          f.close
        end
      end
      
      def template
        @template ||= File.read(File.join(File.dirname(__FILE__), '/../../templates/', template_name))
      end
      
      def template_name
        raise 'Not Implemented!'
      end
    end
  end
end

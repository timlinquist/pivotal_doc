module PivotalDoc
  module Generators
    class Base
      def initialize(items, options={})
        @items= items
        @options= options
      end
      
      def output_path
        @options[:output_path] || absolute_path
      end
      
      def output_file
        File.join(output_path, (@options[:output_file] || self.object_id.to_s) + output_ext)  
      end
      
      def absolute_path
        File.dirname(__FILE__)
      end
      
      def render_doc
        begin
          f= File.open(self.output_file, 'w+')
          html= Haml::Engine.new(template).render(Object.new, {:items => @items})
          f.write(html)
        rescue Exception=>e
          $stdout.print(e.message)
          $stdout.flush
        ensure
          f.close if f
        end
      end
      
      def template
        @template ||= File.read(File.join(File.dirname(__FILE__), '/../../templates/', template_name))
      end
      
      def output_ext; '.default' end
      def template_name
        raise 'Not Implemented!'
      end
    end
  end
end

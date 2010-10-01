# Haml::Engine.new(File.read('index.haml', :local_assigns  => {:foo => foo})
module PivotalDoc
  module Generators
    class Base
      def initialize(items)
        @items= items
      end
      
      def render_doc
        Haml::Engine.new(template, :local_assigns => {:items => @items})
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

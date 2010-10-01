# Haml::Engine.new(File.read('index.haml', :local_assigns  => {:foo => foo})
module PivotalDoc
  module Generators
    class Base
      def initialize(items)
        @items= items
      end
      
      def render_notes
        raise 'Not Implemented (render_notes)!'
      end
    end
  end
end

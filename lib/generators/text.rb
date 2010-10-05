module PivotalDoc
  module Generators
    class Text < Base
      def template_name; 'text_gen.txt' end
      def output_ext; '.txt' end
      def render_doc
        super(output)
      end
    end
  end
end
module PivotalDoc
  module Generators
    class HTML < Base  
      def template_name
        @options['template_name'] || 'output.haml' 
      end
      def output_ext; '.html' end
      def render_doc
        html= Haml::Engine.new(template).render(Object.new, {:sprint=>@sprint})
        super(html)
      end
    end
  end
end

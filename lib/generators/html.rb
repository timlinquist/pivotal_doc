module PivotalDoc
  module Generators
    class HTML < Base  
      def template_name
        @options[:template_name] || 'html_gen.haml' 
      end
      def output_ext; '.html' end
      def render_doc
        html= Haml::Engine.new(template).render(Object.new, {:release=>@release})
        super(html)
      end
    end
  end
end

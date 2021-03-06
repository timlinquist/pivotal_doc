module PivotalDoc
  module Generators
    class Base
      TEMPLATE_PATH= "#{PROJECT_ROOT}/templates"
      
      def initialize(sprint, options={})
        @sprint= sprint
        @options= options
      end
      
      def output_path
        @options['output_path'] || absolute_path
      end
      
      def output_file
        name= @options['output_file']
        unless name
          name=@sprint.release_name || @sprint.project_name || self.object_id.to_s
          name.gsub!(/\//, '') and name.gsub!(/\s/,'')
        end
        File.join(output_path, (name + output_ext))  
      end
      
      def output_ext; '.default' end
      
      def absolute_path
        File.dirname(__FILE__)
      end
      
      def render_doc(output='')
        begin
          # No permissions throw exception about output_path
          FileUtils.mkdir_p(output_path)
          f= File.open(self.output_file, 'w+')
          f.write(output)
        rescue Exception=>e
          $stdout.print(e.message)
          $stdout.flush
        ensure
          f.close if f
        end
      end
      
      def template
        path= File.join(TEMPLATE_PATH, template_name)
        raise TemplateNonExistent.new(template_name) unless File.exists?(path)
        @template ||= File.read(path)
      end
      
      def template_name
        raise 'Not Implemented!'
      end
    end
  end
end

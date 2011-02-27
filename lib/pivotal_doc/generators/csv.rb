require 'fastercsv'

module PivotalDoc
  module Generators
    class CSV < Base
      COLUMNS=[
          'ID', 'Feature', 'Description', 'Requested By', 'Completed By', 
        ]
      def template_name; 'output.csv' end
      def output_ext; '.csv' end
      def render_doc
        output = FasterCSV.generate do |csv|
          csv << COLUMNS 
          self.stories.each{|story| csv << fields(story) }
          self.bugs.each{|story| csv << fields(story) }
          self.chores.each{|story| csv << fields(story) }
        end
        super(output)
      end
      def fields(feature)
        [feature.id, feature.name, feature.description, feature.requested_by, feature.owned_by]
      end
    end
  end
end


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
          csv << COLUMNS.clone 
          @release.features.each {|f| csv << fields(f) }              
        end
        super(output)
      end
      def fields(feature)
        [feature.id, feature.name, feature.description, feature.requested_by, feature.owned_by]
      end
    end
  end
end


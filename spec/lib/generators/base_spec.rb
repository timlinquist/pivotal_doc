require File.dirname(__FILE__) + '/../../spec_helper'

describe PivotalDoc::Generators::Base do
  describe "Rendering the doc" do
    before(:each) do
      @items= {:stories=>[],:chores=>[],:bugs=>[]}
      @base= PivotalDoc::Generators::Base.new(@items)
      @base.stub!(:template).and_return('index.txt')
      @engine= Haml::Engine.new('')
    end
    
    after(:each) do
      File.delete(@base.output_file) if File.exists?(@base.output_file)
    end
    
    it "should render the release doc" do
      Haml::Engine.should_receive(:new).with(@base.template).and_return(@engine)
      @engine.should_receive(:render)
      @base.render_doc
    end
    
    describe "options" do
      it "should be a fully qualified file" do
        base= PivotalDoc::Generators::Base.new(@items, {:output_file=>'my_file'})
        f= File.open(base.output_file, 'w')
        f.should be_an_instance_of(File)
        File.delete(f.path)                
      end
      
      it "should use the output_file if present" do
        base= PivotalDoc::Generators::Base.new(@items, {:output_file=>'my_file'})
        base.output_file.should =~ /\/my_file/        
      end

      it "should default the output_file to the object_id (unique filename for multiple projects)" do
        base= PivotalDoc::Generators::Base.new(@items)
        base.output_file.should =~ /\/#{base.object_id}/        
      end
      
      it "should use the output_path if present" do
        base= PivotalDoc::Generators::Base.new(@items, {:output_path=>'my_path'})
        base.output_path.should =~ /^my_path/
      end

      it "should default the output_path to the relative directory" do
        base= PivotalDoc::Generators::Base.new(@items)
        base.output_path.should =~ /^#{base.absolute_path}/        
      end
    end
    
    it "should open the output file and write the compiled haml (html)" do
      
    end
    
    it "should handle any exceptions and output STDOUT" 
  end
end
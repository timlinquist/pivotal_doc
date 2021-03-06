require 'spec_helper'

describe PivotalDoc::Generators::Base do
  before(:each) do
    @sprint= mocks_helper(:sprint)
    @base= PivotalDoc::Generators::Base.new(@sprint)
  end
  it "should raise an exception if the template doesn't exist" do
    @base.stub!(:template_name).and_return('non-existent.txt')
    lambda{@base.template}.should raise_error(PivotalDoc::TemplateNonExistent)
  end

  describe "Rendering the doc" do
    before(:each) do
      @base.stub!(:template).and_return('index.txt')
    end

    after(:each) do
      File.delete(@base.output_file) if File.exists?(@base.output_file)
    end

    describe "options" do
      it "should be a fully qualified file" do
        base= PivotalDoc::Generators::Base.new(@sprint, {:output_file=>'my_file'})
        f= File.open(base.output_file, 'w')
        f.should be_an_instance_of(File)
        File.delete(f.path)
      end

      it "should use the output_file if present" do
        base= PivotalDoc::Generators::Base.new(@sprint, {'output_file'=>'my_file'})
        base.output_file.should =~ /\/my_file/
      end

      it "should default the output_file to the release's name (unique filename for multiple projects)" do
        base= PivotalDoc::Generators::Base.new(@sprint)
        base.output_file.should =~ /\/#{@sprint.release_name}/
      end

      it "should use the output_path if present" do
        base= PivotalDoc::Generators::Base.new(@sprint, {'output_path'=>'my_path'})
        base.output_path.should =~ /^my_path/
      end

      it "should default the output_path to the relative directory" do
        base= PivotalDoc::Generators::Base.new(@release)
        base.output_path.should =~ /^#{base.absolute_path}/
      end
    end

    it "should open the output file and write the output" do
      output= 'My custom output'
      @base.render_doc(output)
      File.read(@base.output_file).should eql(output)
    end

    it "should handle any exceptions and output STDOUT" do
      File.stub!(:open).and_raise(Exception.new('A MAJOR CATASTROPHE'))
      $stdout.should_receive(:print).with('A MAJOR CATASTROPHE')
      $stdout.should_receive(:flush)
      @base.render_doc
    end
  end
end

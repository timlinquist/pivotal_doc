require File.join(File.dirname(__FILE__), '../lib/pivotal_doc.rb')
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

Spec::Runner.configure do |config|
  config.include MocksHelper
end
  
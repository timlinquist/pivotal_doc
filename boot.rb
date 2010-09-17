require 'rubygems'
require 'pivotal-tracker'

Dir[File.expand_path(File.join(File.dirname(__FILE__),'./lib','**','*.rb'))].each {|f| require f}

if ENV['mode'] == 'test'
  require 'rake'
  require 'spec'
  require 'spec/autorun'
end
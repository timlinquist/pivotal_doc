require 'rubygems'
require 'yaml'
require 'pivotal-tracker'
require 'haml'
PT= PivotalTracker unless defined?(PT)

Dir[File.expand_path(File.join(File.dirname(__FILE__),'./ext','**','*.rb'))].each {|f| require f}
Dir[File.expand_path(File.join(File.dirname(__FILE__),'./lib','**','*.rb'))].each {|f| require f}

if ENV['mode'] == 'test'
  require 'rake'
  require 'spec'
  require 'spec/autorun'
end
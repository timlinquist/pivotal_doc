require 'rubygems'
require 'yaml'
require 'pivotal-tracker'
require 'haml'
PT= PivotalTracker unless defined?(PT)
PROJECT_ROOT= File.join(File.dirname(__FILE__), '/../') unless defined?(PROJECT_ROOT)

Dir[File.expand_path(File.join(File.dirname(__FILE__),'../ext','**','*.rb'))].each {|f| require f}
Dir[File.expand_path(File.join(File.dirname(__FILE__),'pivotal_doc/','**','*.rb'))].each {|f| require f}

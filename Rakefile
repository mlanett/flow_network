require 'bundler'
Bundler::GemHelper.install_tasks

task :default => :test

task :test do
  require "#{File.dirname(__FILE__)}/test/test_helper.rb"
  specs = ( Dir.glob "./test/**/*_spec.rb" )
  specs.each { |spec| require spec }
end

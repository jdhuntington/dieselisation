require 'test/unit'
require 'yaml'
require 'rubygems'
require 'mocha'

libdir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
DIESEL_DIR = implementation_dir = File.join(libdir, 'dieselisation')

require "#{libdir}/dieselisation"
Dir.glob("#{implementation_dir}/*.rb").each do |mod|
  require mod
end


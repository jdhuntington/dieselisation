require 'rubygems'
require 'xmlsimple'
require 'yaml'
require 'pp'

game      = "18AL"
src_dir   = "#{RAILS_ROOT}/raw_data/#{game}"
data_dir  = "#{RAILS_ROOT}/lib/dieselisation/#{game}"

unless File.exists?(data_dir)
  Dir.mkdir(data_dir)
end

Dir.glob("#{src_dir}/*.xml").each do |f|
  f = File.expand_path(f)
  xml = File.read(f)
  raw = XmlSimple.xml_in(xml)
  out_file = f.gsub(/\.xml$/, '.yml')
  open(out_file, 'w') {|file| YAML.dump(raw, file)}
end

### now gather all the data and stuff it into one file
merged_file = File.expand_path("#{data_dir}/game_#{game}.yml")
if File.exist?(merged_file)
  File.delete(merged_file)
end

merged_hash = {}
Dir.glob("#{src_dir}/*.yml").each do |f|
  f = File.expand_path(f)
  merged_hash = merged_hash.merge(YAML.load_file(f))
end
open(merged_file, 'w') {|file| YAML.dump(merged_hash, file)}


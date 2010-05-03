require 'rubygems'
require 'xmlsimple'
require 'yaml'
require 'pp'

game      = "18AL"
src_dir   = "../raw_data/#{game}"
data_dir  = "../lib/dieselisation/#{game}"

unless File.exists?(data_dir)
  Dir.mkdir(data_dir)
end

Dir.entries(src_dir).each do |f|
  if f =~ /.xml/
    xml = File.read("#{src_dir}/#{f}")
    raw = XmlSimple.xml_in(xml)
    # pp raw
    # puts raw.to_yaml
    @out_file = "#{data_dir}/#{f.gsub('.xml', '.yml')}"
    open(@out_file, 'w') {|file| YAML.dump(raw, file)}
    
    # break
  end
end

### now gather all the data and stuff it into one file
merged_file = "#{data_dir}/game_#{game}.yml"
if File.exist?(merged_file)
  File.delete(merged_file)
end

merged_hash = {}
Dir.entries(data_dir).each do |f|
  if f =~ /.yml/
    merged_hash = merged_hash.merge(YAML.load_file("#{data_dir}/#{f}"))
  end
end
open(merged_file, 'w') {|file| YAML.dump(merged_hash, file)}

merged_hash["Company"].each do |c|
  pp "#{c['name']} - #{c['type']}"
end

module Dieselisation
end

Dir[File.join(Rails.root, 'lib', 'dieselisation', '*.rb')].each do |f|
  require File.expand_path(f)
end

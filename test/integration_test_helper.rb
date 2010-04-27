require File.expand_path(File.dirname(__FILE__) + '/test_helper')

I_KNOW_I_AM_USING_AN_OLD_AND_BUGGY_VERSION_OF_LIBXML2 = 'yes'
require 'webrat'
  
Webrat.configure do |config|
  config.mode = :rails
end

require File.join(RAILS_ROOT, 'spec', 'factories', 'all')

class ActiveSupport::TestCase
  
end

# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.load_paths += %W( #{RAILS_ROOT}/lib )
  config.load_paths += %W( #{RAILS_ROOT}/lib/dieselisation )
  config.load_paths += %W( #{RAILS_ROOT}/lib/implementations )

  config.gem "thoughtbot-factory_girl",
             :lib    => "factory_girl",
             :source => "http://gems.github.com"

  config.time_zone = 'UTC'
end

require 'game_18ga'
require 'rpx'

rpx_filename = if File.exist?(File.join(File.dirname(__FILE__), 'rpx.yml'))
                 'rpx.yml'
                 else
                 'rpx.yml.for_testing'
               end
rpx_config = YAML.load(File.read(File.join(File.dirname(__FILE__), rpx_filename)))
$rpx = Rpx::RpxHelper.new rpx_config['api_key'], rpx_config['base_url'], rpx_config['realm']

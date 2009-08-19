# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Add additional load paths for your own custom dirs
  config.load_paths += %W( #{RAILS_ROOT}/lib )
  config.load_paths += %W( #{RAILS_ROOT}/lib/dieselisation )
  config.load_paths += %W( #{RAILS_ROOT}/lib/implementations )

  config.gem "thoughtbot-factory_girl",
             :lib    => "factory_girl",
             :source => "http://gems.github.com"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  config.time_zone = 'UTC'
end

# $:.unshift File.join(File.dirname(__FILE__), '..', 'lib', 'game')
require 'game_18ga'

require 'rpx'
rpx_filename = RAILS_ENV == 'test' ? 'rpx.yml.for_testing' : 'rpx.yml'
rpx_config = YAML.load(File.read(File.join(File.dirname(__FILE__), rpx_filename)))
$rpx = Rpx::RpxHelper.new rpx_config['api_key'], rpx_config['base_url'], rpx_config['realm']

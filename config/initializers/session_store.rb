# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_18GA_session',
  :secret      => '4eae0b445eb9d983327e3a29eaf3d607c9f68b264b7d880d8a8babe9dfbbc94f615e24d16888fd97ee5e807d1a76d9c1a058f07dcf830929d3ec43cb17bcdefc'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

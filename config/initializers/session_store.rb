# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_oin_post_session',
  :secret      => '65b9b8d5e910a42a72816237a17f34f989b1c7849e872f0eb4cbf88b0698049608b9509c8f113c0fbc37efe8580ff8310287a650ac62022fc4de50494a1182dc'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

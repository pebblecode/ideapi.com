# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ipdeapi_session',
  :secret      => '5b86b84172b258cd5cd2a2157fa1f32774134f36511694ccff4b660ff2d3c601c920a9a71252ed643289e136c9d8812a3080877b65ec2342ced28d5415a323ed'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

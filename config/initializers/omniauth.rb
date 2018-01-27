Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['google_oauth2_client_id'], ENV['google_oauth2_client_secret']
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :twitter, 'cQ2tIh8XDnDVNwHT9RapAw', 'QGucJVyhLLyjUfu4QxPqqE7JXxw3lmA17kTsyb8pdg'
  #provider :facebook, '190164707697006', '0e9d9de9410c38c818f925a7e377bbc9'
  #provider :linked_in, 'axpdUGcvbKIco8Z7UHlv06TtvYU2M8a9l0v5eOlHUq1EiIuzUUXYE-SnUO8u7Owv', 'lV8FpQlfwOE4paFH6Q1SRyP7IviaGPGlFY0nZZrAqQEj45AKHNNoFXaqqpjib4hY'
end

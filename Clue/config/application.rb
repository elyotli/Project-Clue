require File.expand_path('../boot', __FILE__)

require 'rails/all'

require 'twitter'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# PROJ_CLUE_CONSUMER_KEY = "pn5orCjkWymq7dLFZwf1rJWLB"
# PROJ_CLUE_CONSUMER_SECRET ="1KzC4wZOgU8qlgZlozDJtL6o1cPWNzSmLGmmuvRg6Tr1OkX0i8"
# PROJ_CLUE_TOKEN = "30163876-h8eLKbPqOR3QAjuakwMTWjk45jgtitn0gQmwtMxk8"
# PROJ_CLUE_TOKEN_SECRET = "PArLmsMPEGZOagLNSd8gkejjNje4mcmEFhNkAOdOF1SSy"


# TWITTER_CLIENT = Twitter::REST::Client.new do |config|
#   config.consumer_key    = PROJ_CLUE_CONSUMER_KEY
#   config.consumer_secret = PROJ_CLUE_CONSUMER_SECRET
# end



module Clue
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end

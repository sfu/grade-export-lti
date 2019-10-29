require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GradeExportApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    config.redis = config_for(:redis)

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Redis configuration
    config.cache_store = :redis_store, "#{Rails.configuration.redis['uri']}/0/cache", { expires_in: 90.minutes }

    # Add timezone to active record
    config.active_record.default_timezone = :local
  end
end

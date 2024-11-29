require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module EcoEssentials
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Add the `lib` directory to autoload and eager load paths
    config.autoload_paths << Rails.root.join("lib")
    config.eager_load_paths << Rails.root.join("lib")

    # Add other subdirectories under `lib` to ignore specific files or folders
    # Explicit ignoring or configuration for subdirectories in `lib` is not standard.
    # Manage your structure in `lib` to follow Rails conventions (like `.rb` files).

    # General application configuration
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # Example: Set your default time zone
    # config.time_zone = "Central Time (US & Canada)"
    #
    # Example: Add additional eager load paths for custom files:
    # config.eager_load_paths << Rails.root.join("extras")
  end
end

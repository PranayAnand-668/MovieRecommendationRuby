require_relative "boot"

require "rails/all"
require "dotenv/load"

Bundler.require(*Rails.groups)

module Movie
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])
  end
end

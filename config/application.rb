require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Moment
  class Application < Rails::Application
    config.load_defaults 5.2
    config.paths.add "#{Rails.root}/lib/coincheck_client", eager_load: true
  end
end

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module StatMaster
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # config.autoload_paths += %W(#{config.root}/app/lib)
    # config.autoload_paths << Rails.root.join('app/lib/results/results')
    # config.autoload_paths << '/app/lib/results/results.rb'
    Dir.glob("#{config.root}/app/lib/results/results.rb").each {|f| require f}
    Dir.glob("#{config.root}/app/lib/results/**/*.rb").each {|f| require f}
    Dir.glob("#{config.root}/app/lib/dynamic_stats/**/*.rb").each {|f| require f}


      # config.autoload_paths << Rails.root.join('app/lib/dynamic_stats')
      # config.autoload_paths << Rails.root.join('app/lib/results')


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end

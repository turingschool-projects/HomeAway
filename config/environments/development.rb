Rails.application.configure do
  config.logger = ActiveSupport::Logger.new(STDOUT)
  config.cache_store = :redis_store, "redis://localhost:6379/1/ns"
  config.cache_classes = true
  config.eager_load = false
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.raise_runtime_errors = true
end

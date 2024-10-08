redis_config = { url: ENV.fetch("REDIS_URL") { "redis://chatapp-redis-1:6379" }  }

Sidekiq.configure_server do |config|
    config.redis = redis_config
end

Sidekiq.configure_client do |config|
    config.redis = redis_config
end
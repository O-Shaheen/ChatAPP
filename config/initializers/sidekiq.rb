redis_config = { url: ENV.fetch("REDIS_URL") { "redis://chatapp-redis-1:6379" }  }

Sidekiq.configure_server do |config|
    config.redis = redis_config
end

Sidekiq.configure_client do |config|
    config.redis = redis_config
end

schedule_file = "config/sidekiq.yml"
if File.exist?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end
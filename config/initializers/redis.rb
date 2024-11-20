require 'redis'

redis_config = { url: ENV.fetch("REDIS_URL") { "redis://chatapp-redis-1:6379" } }
begin
  $redis = Redis.new(redis_config)
rescue Exception => e
  puts e
end


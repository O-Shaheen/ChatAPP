require 'redlock'
begin
    $redis_lock = Redlock::Client.new([ENV.fetch("REDIS_URL") { "redis://chatapp-redis-1:6379/1" }])
  rescue Exception => e
    puts e
end
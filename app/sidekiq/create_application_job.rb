class CreateApplicationJob
    include Sidekiq::Job
  
    def perform(*args)
      params = args[0]
      @application = Application.new(name:params[1])
      @application.token = params[0]
      if @application.save
        $redis.set("#{params[0]}_chat_counter", 0)
        return true
      else
        return false
      end
    
    end
  end
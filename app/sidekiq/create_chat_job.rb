class CreateChatJob
    include Sidekiq::Job
    
    def perform(*args)
      params = args[0]
      @application = Application.find_by(token: params[1])
      @chat = @application.chats.new(name:params[2])
      @chat.number = params[0]
      @application.increment!(:chat_count)
      @chat.save
      $redis.set("#{params[1]}_#{params[0]}_message_counter", 1)
      @application.with_lock do
        @application.save
      end    
    end
  end
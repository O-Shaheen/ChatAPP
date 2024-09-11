class UpdateChatJob
    include Sidekiq::Job
  
    def perform(*args)
      params = args[0]
      @chat = Chat.find_by(number: params[1], application_id: params[0])    
      @chat.with_lock do
        @chat.update(name:params[2])
        @chat.save
      end
    end
  end
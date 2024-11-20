class CreateMessageJob
    include Sidekiq::Job
    
    def perform(*args)
      params = args[0]
      @chat = Chat.find_by(application_id: params[0], number: params[1])
      @message = @chat.messages.new(body:params[2])
      @message.number = params[3]
      @message.save
      @chat.with_lock do
        @chat.save
      end    
    end
  end
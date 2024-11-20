class UpdateMessageJob
    include Sidekiq::Job
  
    def perform(*args)
      params = args[0]
      @message = Message.find_by(number: params[0], chat_id: params[1])
      @message.update(body:params[2])
      @message.save
    end
  end
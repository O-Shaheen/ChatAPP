class MessageCountUpdateCron
    include Sidekiq::Worker
  
    def perform(*args)
      Chat.all.each do |chat|
        puts "message_count_update_cron - Messages counting job starts"
        chat.message_count = Message.where(chat_id: chat.id).length()
        unless chat.save
          puts "message_count_update_cron - An error occurred while writing the message count to the chat"
        end
      end
    end
  end
  
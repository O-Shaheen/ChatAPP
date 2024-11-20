class ChatCountUpdateCron
    include Sidekiq::Worker
  
    def perform(*args)
        Application.all.each do |application|
            puts "chat_count_update_cron - chat counting job starts"
            application.chat_count = Chat.where(application_id: application.id).length()
            unless application.save
            puts "chat_count_update_cron - An error occurred while writing the message count to the chat"
            end
        end
    end
end
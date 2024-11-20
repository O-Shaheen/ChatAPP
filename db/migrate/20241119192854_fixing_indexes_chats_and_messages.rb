class FixingIndexesChatsAndMessages < ActiveRecord::Migration[7.1]
  def change
    # Removing index from chats table on application_id
    remove_index :chats, name: 'index_chats_on_application_id'
    
    # Removing index from messages table on chat_id
    remove_index :messages, name: 'index_messages_on_chat_id'
  end
end

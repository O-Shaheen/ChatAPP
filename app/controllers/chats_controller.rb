class ChatsController < ApplicationController
    before_action :set_application 
    before_action :chat_params_filter, only: [:create, :update]
    protect_from_forgery unless: -> { request.format.json? }

    def index
      chats = @application&.chats&.map {  |chat| { name: chat.name, message_count: chat.message_count, number: chat.number, created_at: chat.created_at } } || []
      render json: chats, status: :ok
    end

    def create
      chat_counter = get_chat_count

      obj = [
        chat_counter,
        params[:application_id], 
        params[:name]

      ]
      CreateChatJob.perform_async(obj)
      render json: {number: chat_counter, message_count: 0}, status: :created
    end

    def update
      chat_counter = params[:id]
      input_application_id = @application.id
      input_name = params[:name]
      obj = [
        input_application_id, 
        chat_counter, 
        input_name
      ]
      UpdateChatJob.perform_async(obj)
      render json: { name: input_name, chat_number: chat_counter }, status: :ok
    end

    def destroy
      @chat = Chat.find_by(number: params[:id], application_id: @application.id)
      
      if @chat.destroy
        @application.decrement!(:chat_count)
        @application.with_lock do
          @application.save
        end
        render json: { message: 'Chat and its messages successfully deleted' }, status: :ok
      else
        render json: { error: 'Chat not found' }, status: :not_found
      end
    end

  
    private
    def get_chat_count
      key = "#{params[:application_id]}_chat_counter"
      counter = $redis.incr(key)
      return counter
    end

    def set_application
      @application = Application.find_by!("token": params[:application_id])
    end

    def chat_params_filter
      params.require(:chat).permit(:name)
    end

end
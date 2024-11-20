class MessagesController < ApplicationController
    before_action :set_chat
    before_action :message_params_filter, only: [:create, :update]
    protect_from_forgery unless: -> { request.format.json? }

    def index
      messages = @chat&.messages&.map { |message| { body: message.body, number: message.number, created_at: message.created_at } } || []
      render json: messages, status: :ok
    end
  
    def create

        input_message_count = get_message_count
        obj = [
            @application.id, 
            @chat.number,
            params[:body],
            input_message_count
          ]

        CreateMessageJob.perform_async(obj)
        render json: {number: input_message_count, body: params[:body]}, status: :created
    end

    def update
        obj = [
            params[:id], 
            @chat.id,
            message_params_filter[:body]
        ]
        UpdateMessageJob.perform_async(obj)
        render json: { body: message_params_filter[:body], number: params[:id] }, status: :ok
    end

    def destroy
      @message = Message.find_by(number: params[:id], chat_id: @chat.id)
      
      if @message.destroy
        @chat.decrement!(:message_count)
        @chat.with_lock do
          @chat.save
        end
        render json: { message: 'Message successfully deleted' }, status: :ok
      else
        render json: { error: 'Message not found' }, status: :not_found
      end
    end


    def search
      query = {
        query: {
          query_string: {
            query: "*#{params[:query]}*",
            fields: ['body'],
            default_operator: 'AND'
          }
        },
        _source: ['body', 'number', 'created_at']
      }
    
      @messages = @chat.messages.search(query).records.select { |message| message.chat_id == @chat.id }.map do |message|
        {
          body: message.body,
          number: message.number,
          created_at: message.created_at
        }
      end
    
      render json: @messages
    end


    private
  
    def set_chat
      @application = Application.find_by!(token: params[:application_id])
      if @application == nil
        render json: { error: 'Application not found' }, status: :not_found
        return
      end
      @chat = Chat.find_by(application_id: @application.id, number: params[:chat_id])
      if @chat == nil
        render json: { error: 'Chat not found' }, status: :not_found
        return
      end
    end

    def get_message_count
      key = "#{params[:application_id]}_#{params[:chat_id]}_message_counter"
      counter = $redis.incr(key)
      return counter
      end
  
    def message_params_filter
      params.require(:message).permit(:body)
    end
  end
  
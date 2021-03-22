module Api
  class MessagesController < ApplicationController
    before_action :set_application, only: %i[index show update search]
    before_action :set_chat, only: %i[index show update search]

    def index
      messages = @chat.messages
      render json: messages.as_json(only: [:number, :body]), status: :ok
    end

    def show
      message = @chat.messages.find_by number: params[:number]
      render json: message.as_json(only: [:number, :body]), status: :ok
    end

    def create
      redis_key = "#{params[:application_token]}_#{params[:chat_number]}"

      # messages_count: represent both messages_count in Chats table and message_number in Messages table
      # It will increment if exists or intialize with 1
      messages_count = REDIS_CLIENT.incr("#{params[:application_token]}_#{params[:chat_number]}")

      HandleMessageCreationWorker.perform_async(params[:application_token], params[:chat_number], messages_count, params[:body])

      render json: { message_number: messages_count }, status: :ok
    end

    def update
      message = @chat.messages.find_by number: params[:number]
      message.update(message_params)

      render json: message.as_json(only: [:number, :body]), status: :ok
    end

    def search
      results = Message.search_body(@chat.id.to_i, params[:body])
      render json: results.as_json(only: [:number, :body]), status: :ok
    end

    private

    def set_application
      @application = Application.find_by token: params[:application_token]
    end

    def set_chat
      @chat = @application.chats.find_by(number: params[:chat_number])
    end

    def message_params
      params.require(:message).permit(:body)
    end
  end
end
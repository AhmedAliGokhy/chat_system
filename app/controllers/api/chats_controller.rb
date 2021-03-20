module Api
  class ChatsController < ApplicationController
    before_action :set_application, only: %i[index show]

    def index
      chats = @application.chats
      render json: chats.as_json(only: :number), status: :ok
    end

    def show
      chat = @application.chats.find_by(number: params[:number])
      render json: chat.as_json(only: :number), status: :ok
    end

    def create
      # chats_count: represent both chats_count in Applications table and chat_number in Chats table
      # It will increment if exists or intialize with 1
      chats_count = REDIS_CLIENT.incr(params[:application_token])
      HandleChatCreationWorker.perform_async(chats_count, params[:application_token])
      
      render json: { chat_number: chats_count }, status: :ok
    end

    private

    def set_application
      @application = Application.find_by token: params[:application_token]
    end
  end
end
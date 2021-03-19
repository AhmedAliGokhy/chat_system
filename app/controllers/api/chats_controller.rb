module Api
  class ChatsController < ApplicationController
    def create
      # chats_count: represent both chats_count in Applications table and chat_number in Chats table
      # It will increment if exists or intialize with 1
      chats_count = REDIS_CLIENT.incr(params[:application_token])
      HandleChatCreationWorker.perform_async(chats_count, params[:application_token])
      
      render json: { chat_number: chats_count }, status: :ok
    end
  end
end
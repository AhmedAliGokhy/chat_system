module Api
  class ChatsController < ApplicationController
    def create
      redis = Redis.new
      chats_count = redis.incr(params[:application_token])
      HandleChatCreationWorker.perform_async(chats_count, params[:application_token])
      
      render json: { chat_number: chats_count }, status: :ok
    end
  end
end
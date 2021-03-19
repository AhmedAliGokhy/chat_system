module Api
  class MessagesController < ApplicationController
    def create
      redis = Redis.new
      redis_key = "#{params[:application_token]}_#{params[:chat_number]}"

      # messages_count: represent both messages_count in Chats table and message_number in Messages table
      # It will increment if exists or intialize with 1
      messages_count = redis.incr("#{params[:application_token]}_#{params[:chat_number]}")

      HandleMessageCreationWorker.perform_async(params[:application_token], params[:chat_number], messages_count, params[:body])

      render json: { message_number: messages_count }, status: :ok
    end
  end
end
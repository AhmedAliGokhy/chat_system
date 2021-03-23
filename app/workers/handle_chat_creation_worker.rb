class HandleChatCreationWorker
  include Sidekiq::Worker

  def perform(chats_count, application_token)
    application = Application.find_by(token: application_token)
    application.update(chats_count: chats_count) if application.chats_count < chats_count

    # Insert chat record
    application.chats.where(number: chats_count).first_or_create

    # Insert new key in redis to store messages_count
    REDIS_CLIENT.set("#{application.token}_#{chats_count}", 0)
  end
end

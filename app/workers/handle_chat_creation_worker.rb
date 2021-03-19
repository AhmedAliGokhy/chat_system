class HandleChatCreationWorker
  include Sidekiq::Worker

  def perform(chats_count, application_token)
    application = Application.find_by(token: application_token)
    application.update(chats_count: chats_count) if application.chats_count < chats_count

    # Insert chat record
    application.chats.create(number: chats_count)

    # Insert new key in redis to store messages_count
    REDIS_CLIENT.set("#{application.token}_#{chats_count}", 0)
  end
end

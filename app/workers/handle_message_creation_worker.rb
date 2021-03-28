class HandleMessageCreationWorker
  include Sidekiq::Worker

  def perform(application_token, chat_number, messages_count, body)
    application = Application.find_by(token: application_token)
    chat = application.chats.find_by(number: chat_number)
    raise "Chat number not found (Maybe not inserted yet)" unless chat
    chat.update(messages_count: messages_count) if chat.messages_count < messages_count

    # Insert message record
    chat.messages.create(number: messages_count, body: body)
  end
end

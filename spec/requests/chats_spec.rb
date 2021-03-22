require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.inline!

RSpec.describe "Chats", type: :request do
  describe "Get /api/applications/:token/chats" do
    let!(:application_1) { FactoryBot.create(:application) }
    let!(:application_2) { FactoryBot.create(:application) }
    let!(:chats_1) { FactoryBot.create_list(:chat, 10, application: application_1) }
    let!(:chats_2) { FactoryBot.create_list(:chat, 10, application: application_2) }

    it 'returns all chats for specific application' do
      get "/api/applications/#{application_1.token}/chats"

      expect(JSON.parse(response.body).size).to eq(10)
    end
  end

  describe "Get /api/applications/:token/chat/:number" do
    let!(:application) { FactoryBot.create(:application) }
    let!(:chats) { FactoryBot.create_list(:chat, 5, application: application) }

    it 'returns the chat for specific application' do
      get "/api/applications/#{application.token}/chats/#{chats.first.number}"
      
      expect(JSON.parse(response.body)["number"]).to eq(chats.first.number)
    end
  end

  describe "Post /api/applications/:token/chats" do
    let!(:application) { FactoryBot.create(:application) }

    it 'returns a new chat' do
      post "/api/applications/#{application.token}/chats"
      chat = JSON.parse(response.body)
      application_token = application.token
      application = Application.find_by(token: application_token)
      
      expect(REDIS_CLIENT.get(application.token).to_i).to eq(application.chats_count)
      expect(response.status).to eq(200)
    end
  end
end

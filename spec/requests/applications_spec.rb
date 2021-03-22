require 'rails_helper'

RSpec.describe "Applications", type: :request do
  describe "Get /api/applications" do
    let!(:applications) { FactoryBot.create_list(:application, 20) }

    it 'returns all applications' do
      get '/api/applications'

      expect(JSON.parse(response.body).size).to eq(20)
    end
  end

  describe "Get /api/applications/:token" do
    let!(:application) { FactoryBot.create(:application) }

    it 'returns the application' do
      get "/api/applications/#{application.token}"
      
      expect(JSON.parse(response.body)["name"]).to eq(application.name)
    end
  end

  describe "Post /api/applications" do
    it 'returns a new application' do
      post "/api/applications", params: { application: { name: "New Test" } }
      application = JSON.parse(response.body)
      
      expect(REDIS_CLIENT.get(application["token"])).to eq("0")
      expect(application["name"]).to eq("New Test")
    end
  end

  describe "Patch /api/applications/:token" do
    context "valid params" do
      it 'updates the application' do
        post "/api/applications", params: { application: { name: "Test" } }
        application = JSON.parse(response.body)
  
        put "/api/applications/#{application["token"]}", params: { application: { name: "New Test" } }
        new_application = JSON.parse(response.body)
        
        expect(REDIS_CLIENT.get(application["token"])).to eq("0")
        expect(new_application["name"]).to eq("New Test")
      end
    end

    context "unvalid params" do
      it 'updates the application' do
        post "/api/applications", params: { application: { name: "Test" } }
        application = JSON.parse(response.body)
  
        put "/api/applications/#{application["token"]}", params: { application: { name: "" } }
        
        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)).to eq({"name"=>["can't be blank"]})
        expect(REDIS_CLIENT.get(application["token"])).to eq("0")
      end
    end
  end
end

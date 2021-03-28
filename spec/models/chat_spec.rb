require 'rails_helper'

RSpec.describe Chat, type: :model do
  let(:application) { FactoryBot.create(:application) }
  let(:new_application) { FactoryBot.create(:application) }

  let(:chat) { FactoryBot.create(:chat, application: application, number: 1) }
  
  subject { described_class.new(
    application: application,
    number: 1
  ) }
  
  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid witout application" do
    subject.number = nil
    expect(subject).to_not be_valid
  end

  it "is not valid witout number" do
    subject.application = nil
    expect(subject).to_not be_valid
  end

  it "is not valid to duplicate number within same application" do
    subject.application = application
    subject.number = chat.number

    expect(subject).to_not be_valid
  end

  it "is valid to duplicate number with another application" do
    subject.application = new_application
    subject.number = chat.number

    expect(subject).to be_valid
  end
end
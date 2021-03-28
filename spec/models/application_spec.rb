require 'rails_helper'

RSpec.describe Application, type: :model do
  let(:application) { FactoryBot.create(:application) }
  
  subject { described_class.new(
    name: "Test",
    token: SecureRandom.uuid
  ) }
  
  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid witout name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end
end
FactoryBot.define do
  factory :application, class: Application do
    name { Faker::Name.name }
  end

  factory :chat, class: Chat do
    application
    number { Faker::Number.between(from: 1, to: 10000) }
  end
end
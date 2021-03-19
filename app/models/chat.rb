class Chat < ApplicationRecord
  # Associations
  belongs_to :application
  has_many :messages
end

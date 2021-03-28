class Chat < ApplicationRecord
  # Associations
  belongs_to :application
  has_many :messages

  # Validations
  validates :number, presence: true
  validates :number, uniqueness: { scope: :application }
end

class Application < ApplicationRecord
  # Associations
  has_many :chats
  
  # Validations
  validates_presence_of :name
  validates_uniqueness_of :token

  # Callbacks
  before_create :set_token

  private

  def set_token
    self.token = SecureRandom.uuid
  end
end
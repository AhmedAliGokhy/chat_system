class Application < ApplicationRecord
  # Validations
  validates_presence_of :name
  validates_uniqueness_of :token

  # Callbacks
  before_create :set_token

  private

  def set_token
    loop do
      self.token = SecureRandom.uuid
      break unless Application.where(token: self.token).exists?
    end
  end
end
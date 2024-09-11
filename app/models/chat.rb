class Chat < ApplicationRecord
  belongs_to :application
  has_many :messages, dependent: :destroy

  # validates :number, presence: false, uniqueness: { scope: :application_id }
  # validates :name, presence: true


  # def set_chat_number
  #   application_token = self.application.token
  #   self.number = $redis.hincrby("chat_numbers", application_token, 1)
  # end

  # def self.total_chats_by_application(token)
  #   joins(:application).where(applications: { token: token }).count
  # end

end
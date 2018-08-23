class TelegramService
  require 'faraday'
  require 'json'

  attr_accessor :user, :conn

  def initialize(user)
    @user ||= user
    @conn ||= Faraday.new(url: base_url)
  end

  def updates
    JSON.parse(@conn.get('getUpdates').body)
  end

  def set_up_webhook
    JSON.parse(@conn.get('setWebhook', url: 'https://lamia.serveo.net/webhook_provider/telegram').body)
  end

  def send_message(text: '', body: {})
    JSON.parse(@conn.get('sendMessage', chat_id: body[:chat_id], text: text).body)
  end

  def self.get_user
  end

  private

  def access_token
    ## Should be read from secrets or ENV - Bot Access Token
    '636172450:AAGBipqKKNeUxgEWSb2CNBrjcwuLzGU6zww'
  end

  def base_url
    "https://api.telegram.org/bot#{access_token}/"
  end
end

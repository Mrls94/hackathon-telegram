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
    JSON.parse(@conn.get('sendMessage', chat_id: chat_id, text: text).body)
  end

  def self.get_user(params)
    chat_id = params[:message]['chat']['id'].to_s
    user = User.find_by(
      "provider_info -> 'telegram' ->> 'chat_id' = ?",
      chat_id
    )

    if user.nil?
      user = User.create(provider_info: { telegram: { chat_id: chat_id } })
    end

    user
  end

  private

  def access_token
    ## Should be read from secrets or ENV - Bot Access Token
    ENV['TELEGRAM_ACCESS_TOKEN']
  end

  def base_url
    "https://api.telegram.org/bot#{access_token}/"
  end

  def chat_id
    @user.provider_info['telegram']['chat_id']
  end
end

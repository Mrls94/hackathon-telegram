class TelegramService
  require 'faraday'
  require 'json'

  attr_accessor :user, :conn

  def initialize(user)
    @user ||= user
    @conn ||= self.class.conn
  end

  class << self
    def conn
      @conn ||= Faraday.new(base_url)
    end

    def base_url
      "https://api.telegram.org/bot#{Rails.application.secrets[:telegram][:access_token]}/"
    end

    def webhook_setup(webhook_url)
      JSON.parse(conn.get('setWebhook', url: webhook_url).body)
    end

    def get_user(params)
      chat_id = params[:message]['chat']['id'].to_s
      user = User.find_by("provider_info -> 'telegram' ->> 'chat_id' = ?", chat_id)

      user = User.create(provider_info: { telegram: { chat_id: chat_id } }) if user.nil?
      user
    end
  end

  def send_message(text: '', body: {})
    JSON.parse(@conn.get('sendMessage', chat_id: chat_id, text: text).body)
  end

  private

  def chat_id
    @user.provider_info['telegram']['chat_id']
  end
end

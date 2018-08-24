class TrelloService
  require 'faraday'
  require 'json'

  attr_accessor :user, :conn

  def initialize(user)
    @user ||= user
    @conn ||= Faraday.new(url: base_url)
  end

  private

  def access_token
    ## Should be read from secrets or ENV - Bot Access Token
    '636172450:AAGBipqKKNeUxgEWSb2CNBrjcwuLzGU6zww'
  end

  def base_url
    "https://api.trello.com/"
  end
end

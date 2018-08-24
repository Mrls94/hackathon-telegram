class TrelloService
  require 'faraday'
  require 'json'

  attr_accessor :user, :conn

  def initialize(user)
    @user ||= user
    @conn ||= Faraday.new(url: base_url)
  end

  def board_info(board_id = 'kxmN1Z4u')
    JSON.parse(get("boards/#{board_id}").body)
  end

  private

  def secret
    ## Should be read from secrets or ENV - Bot Access Token
    '91c29fc8b88dab7a484735c264399c6a92ef9858e505c3a57f3b459e8349b3cd'
  end

  def board_id
    'kxmN1Z4u'
  end

  def base_url
    "https://api.trello.com/1/"
  end

  def get(resource, body={})
    @conn.get(resource, body.merge(key: api_key, token: token))
  end

  def token
    'e9eb27d29b484273ff059426f76725a43582c927446a9f90576afb631b6974bb'
  end

  def api_key
    ## Should be read from secrets or ENV - Bot Access Token
    '6171ca7feafb4fde24846f2eba5c6ba8'
  end
end

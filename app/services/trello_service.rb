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

  def sync_issues(issues)
    lists_object = lists
    created_lists = []
    missing_lists(lists_object).each do |list_name|
      created_lists << create_list(name: list_name)
    end

    # Get Backlog id
    backlog = lists_object.select { |list| list['name'] == 'backlog' }.first
    backlog = created_lists.select { |list| list['name'] == 'backlog' }.first if backlog.nil?

    # Create cards with issue data
    issues.each do |issue|
      create_card(idList: backlog['id'], name: issue[:name], desc: issue[:desc])
    end
  end

  def create_list(body)
    JSON.parse(post("boards/#{board_id}/lists", body).body)
  end

  def lists
    JSON.parse(get("boards/#{board_id}/lists").body)
  end

  def create_card(body)
    JSON.parse(post('cards', body).body)
  end

  private

  def missing_lists(lists_object)
    constant_lists - lists_object.map { |list| list['name'] }
  end

  def constant_lists
    ['completed', 'in progress', 'backlog']
  end

  def secret
    ## Should be read from secrets or ENV - Bot Access Token
    Rails.application.secrets[:trello][:secret]
  end

  def board_id
    @user.task_manager_info['trello']['board_id']
  end

  def base_url
    "https://api.trello.com/1/"
  end

  def get(resource, body = {})
    @conn.get(resource, body.merge(key: api_key, token: token))
  end

  def post(resource, body = {})
    @conn.post(resource, body.merge(key: api_key, token: token))
  end

  def token
    @user.task_manager_info['trello']['token']
  end

  def api_key
    ## Should be read from secrets or ENV - Bot Access Token
    Rails.application.secrets[:trello][:api_key]
  end
end

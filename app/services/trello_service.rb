class TrelloService
  attr_accessor :user

  def initialize(user)
    @user ||= user
  end

  def client
    Faraday.new('https://api.trello.com/1/')
  end

  def board_info
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

  def lists
    JSON.parse(get("boards/#{board_id}/lists").body)
  end

  def create_card(body)
    JSON.parse(post('cards', body).body)
  end

  def create_list(name)
    JSON.parse(post("boards/#{board_id}/lists", name: name, pos: 'bottom').body)
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

  def token
    @user.task_manager_info.dig('trello', 'token')
  end

  def board_id
    @user.task_manager_info.dig('trello', 'board_id')
  end

  def api_key
    @user.task_manager_info.dig('trello', 'key')
  end

  def api_key
    ## Should be read from secrets or ENV - Bot Access Token
    Rails.application.secrets[:trello][:api_key]
  end

  def get(path, params = {})
    client.get(path) do |req|
      req.params[:key] = api_key
      req.params[:token] = token
      req.body = params
      yield(req) if block_given?
    end
  end

  def post(path, params = {})
    client.post(path) do |req|
      req.params[:key] = api_key
      req.params[:token] = token
      req.body = params
      yield(req) if block_given?
    end
  end
end

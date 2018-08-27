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

  def create_list(name)
    JSON.parse(post("boards/#{board_id}/lists", name: name, pos: 'bottom').body)
  end

  private

  def token
    @user.task_manager_info.dig('trello', 'token')
  end

  def board_id
    @user.task_manager_info.dig('trello', 'board_id')
  end

  def api_key
    @user.task_manager_info.dig('trello', 'key')
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

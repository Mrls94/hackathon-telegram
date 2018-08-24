class GithubService
  class << self
    def client
      Faraday.new('https://api.github.com')
    end

    def list_issues(owner, repo_name)
      response = client.get("/repos/#{owner}/#{repo_name}/issues")
      raise "Status Error: #{response.status}" unless response.status.between?(200, 299)
      begin
        JSON.parse(response.body)
      rescue => _e
        response.body
      end
    end
  end
end

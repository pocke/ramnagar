module Ramnagar
  module Converter
    extend self

    def convert(query, github_access_token:)
      case query
      when /^user:/
        convert_user_query(query, github_access_token: github_access_token)
      else
        raise "unexpected: #{query}"
      end
    end

    private def convert_user_query(query, github_access_token:)
      user = query[/^user:(.+)/, 1]
      client = Client.new(github_access_token: github_access_token)
      client.repositories(user: user)
        .select { |repo| repo[:viewerSubscription] == 'SUBSCRIBED' }
        .map { |repo| "repo:" + repo[:nameWithOwner] }
    end
  end
end

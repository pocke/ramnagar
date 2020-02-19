module Ramnagar
  class Client
    class RequestError < StandardError
      def initialize(errors)
        @errors = errors
      end

      def message
        @errors.map{|e| e[:message]}.join("\n")
      end
    end

    USER_REPOSITORIES_QUERY = <<~GRAPHQL
      query($login: String!, $first: Int!, $after: String) {
        repositoryOwner(login: $login) {
          repositories(first: $first, after: $after) {
            nodes {
              nameWithOwner
              viewerSubscription
            }
            pageInfo {
              endCursor
              hasNextPage
            }
          }
        }
      }
    GRAPHQL

    def initialize(github_access_token:)
      @github_access_token = github_access_token
    end

    def repositories(user:)
      paginate do |after|
        resp = req(query: USER_REPOSITORIES_QUERY, variables: { login: user, first: 100, after: after })
        resp[:data][:repositoryOwner][:repositories]
      end
    end

    private def req(query:, variables: {})
      http = Net::HTTP.new('api.github.com', 443)
      http.use_ssl = true
      header = {
        "Authorization" => "Bearer #{github_access_token}",
        'Content-Type' => 'application/json',
      }
      resp = http.request_post('/graphql', JSON.generate({ query: query, variables: variables }), header)
      JSON.parse(resp.body, symbolize_names: true).tap do |content|
        raise RequestError.new(content[:errors]) if content[:errors]
      end
    end

    private def paginate(after = nil, &block)
      has_next_page = true
      nodes = []

      while has_next_page
        connection = block.call(after)
        nodes.concat connection[:nodes]
        has_next_page = connection[:pageInfo][:hasNextPage]
        after = connection[:pageInfo][:endCursor]
      end

      nodes
    end

    private
    attr_reader :github_access_token
  end
end

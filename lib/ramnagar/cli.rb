module Ramnagar
  class CLI
    # GitHub's limitation.
    # GitHub truncates query that is over 1024 characters.
    MAX_QUERY_LENGTH = 1024

    def initialize(argv)
      @argv = argv
    end

    def run
      github_access_token = ENV['GITHUB_ACCESS_TOKEN']

      result = []
      @argv.each do |q|
        result.concat(Converter.convert(q, github_access_token: github_access_token))
      end

      slice_queries(result).each do |slice|
        puts slice
      end
    end

    private def slice_queries(queries)
      buf = +""
      res = []
      queries = queries.dup

      while q = queries.pop
        if (buf + q).size + 1 > MAX_QUERY_LENGTH
          res << buf
          buf = +""
        else
          if buf.empty?
            buf << q
          else
            buf << ' ' << q
          end
        end
      end
      res << buf unless buf.empty?

      res
    end
  end
end

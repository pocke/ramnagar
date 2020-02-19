module Ramnagar
  class CLI
    def initialize(argv)
      @argv = argv
    end

    def run
      github_access_token = ENV['GITHUB_ACCESS_TOKEN']

      result = []
      @argv.each do |q|
        result.concat(Converter.convert(q, github_access_token: github_access_token))
      end

      puts result.join(' ')
    end
  end
end

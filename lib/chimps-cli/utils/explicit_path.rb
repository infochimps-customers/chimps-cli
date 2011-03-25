module Chimps
  module Utils

    module ExplicitPath

      def raw_path
        raise CLIError.new(self.class::USAGE) unless config.argv.size > 1
        config.argv[1]
      end

      def query_params
        return {} unless raw_path.include?('?')
        {}.tap do |h|
          raw_path.split('?')[1].split('&').each do |pair|
            name, value = pair.split('=').map { |string| CGI::unescape(string) }
            h[name] = value
          end
        end
      end

      def path
        p = raw_path.split('?').first
        p =~ /\.(\w+)$/i ? p : "#{p}.#{response_fmt}"
      end

    end
  end
end

    

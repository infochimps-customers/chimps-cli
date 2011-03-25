module Chimps
  module Commands

    class Search < Chimps::Command

      include Chimps::Utils::HttpFormat
      include Chimps::Utils::ActsOnResource

      def self.allowed_resources
        %w[dataset]
      end

      def self.allowed_response_fmts
        super().concat(['tsv'])
      end

      def self.default_response_fmt
        'tsv'
      end
      
      USAGE = "usage: chimps search [OPTIONS] QUERY"
      HELP   = <<EOF

Search for #{default_resources_type} on Infochimps for the given
QUERY.

Examples:

  $ chimps search music                    # search all datasets for 'music'
  $ chimps search --my 'finance AND nyse'  # search your datasets for 'finance' and 'nyse'
EOF
      
      def query
        raise CLIError.new(self.class::USAGE) if config.rest.size < 2
        config.rest[1..-1].join(' ')
      end
      
      def query_params
        {:query => query}.tap do |qp|
          qp[:skip_header] = true if config[:skip_column_names]
        end
      end

      def path
        config[:my] ? "/my/search.#{response_fmt}" : "/search.#{response_fmt}"
      end

      def execute!
        Request.new(path, :query_params => query_params, :sign => config[:my]).get(headers).print(config)
      end
    end
  end
end


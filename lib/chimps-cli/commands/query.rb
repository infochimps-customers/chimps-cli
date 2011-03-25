module Chimps
  module Commands

    # A command to issue a GET request against the Infochimps paid
    # query API.
    class Query < Chimps::Command

      include Chimps::Utils::UsesParamValueData      

      USAGE = "usage: chimps query [OPTIONS] ENDPOINT [PROP=VALUE] ..."
      HELP   = <<EOF

Send a query to the given ENDPOINT on the Infochimps Query API with the
given parameters.

#{how_to_input_data}
You can learn more about the Infochimps query API, discover datasets
to query, and look up the available parameters at

  http://api.infochimps.com

Examples:

  $ chimps query soc/net/tw/trstrank screen_name=infochimps
  $ chimps query soc/net/tw/trstrank?screen_name=infochimps
  $ chimps query web/an/de/demographics ip=146.6.180.1
  $ chimps query soc/net/tw/trstrank --data=trstrank_queries.yml
EOF

      def endpoint
        raise CLIError.new(self.class::USAGE) unless config.argv.size > 1 && (! config.argv[1].empty?)
        config.argv[1]
      end

      def requests
        # ensure_data_is_present! unless endpoint.include?("?")
        if data.is_a?(Hash)
          [QueryRequest.new(endpoint, :query_params => data, :sign => true)]
        else
          data.map { |params| QueryRequest.new(endpoint, :query_params => params, :sign => true) }
        end
      end
      
      def execute!
        requests.each do |request|
          response = request.get
          if response.error?
            response.print :to => $stderr
          else
            puts(config[:pretty] ? JSON.pretty_generate(JSON.parse(response.body)) : response.body)
          end
        end
      end
      
    end
  end
end


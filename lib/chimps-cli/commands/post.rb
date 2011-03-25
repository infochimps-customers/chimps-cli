module Chimps
  module Commands

    class Post < Chimps::Command

      include Chimps::Utils::HttpFormat
      include Chimps::Utils::ExplicitPath
      include Chimps::Utils::UsesParamValueData

      USAGE = "usage: chimps post [OPTIONS] PATH [PARAM=VALUE] ..."
      HELP   = <<EOF

Send a GET request to the given PATH at Infochimps.

Examples:

  # create a dataset
  $ chimps post /datasets title="List of Chimps" description="Awesome..."

  # create a source
  $ chimps post /sources --data=/path/to/some/metadata.json
EOF
      
      def execute!
        response = Chimps::Request.new(path, :query_params => query_params, :data => (data || true), :sign => config[:sign]).post(headers)
        response.print_headers if config[:headers]
        response.print
      end

    end
  end
end


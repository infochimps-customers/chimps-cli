module Chimps
  module Commands

    class Get < Chimps::Command

      include Chimps::Utils::HttpFormat
      include Chimps::Utils::ExplicitPath

      USAGE = "usage: chimps get [OPTIONS] PATH"
      HELP   = <<EOF

Send a GET request to the given PATH at Infochimps.

Examples:

  $ chimps get /datasets                        # list datasets (#{default_response_fmt} by default)
  $ chimps get /datasets --response_format=yaml # in YAML
  $ chimps get /sources/1.xml                   # look at source 1 in XML
EOF

      def execute!
        response = Chimps::Request.new(path, :query_params => query_params, :sign => config[:sign]).get(headers)
        response.print_headers if config[:headers]
        response.print
      end

    end
  end
end


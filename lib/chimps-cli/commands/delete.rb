module Chimps
  module Commands

    class Delete < Chimps::Command

      include Chimps::Utils::HttpFormat
      include Chimps::Utils::ExplicitPath

      USAGE = "usage: chimps delete [OPTIONS] PATH"
      HELP   = <<EOF

Send a DELETE request to the given PATH at Infochimps.

Examples:

  $ chimps delete /datasets/my-crappy-dataset
  $ chimps delete /sources/my-broken-source
EOF

      def execute!
        response = Chimps::Request.new(path, :query_params => query_params, :sign => config[:sign]).delete(headers)
        response.print_headers if config[:headers]
        response.print
      end

    end
  end
end


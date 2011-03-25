module Chimps
  module Commands

    class Put < Chimps::Command

      include Chimps::Utils::HttpFormat
      include Chimps::Utils::ExplicitPath
      include Chimps::Utils::UsesParamValueData

      USAGE = "usage: chimps put [OPTIONS] PATH [PARAM=VALUE] ..."
      HELP   = <<EOF

Send a GET request to the given PATH at Infochimps.

Examples:

  # update a dataset
  $ chimps put /datasets/my-dataset title="A new title"

  # update a source
  $ chimps put /sources/my-source --data=/path/to/new/metadata.yaml
EOF
      
      def execute!
        response = Chimps::Request.new(path, :query_params => query_params, :data => (data || true), :sign => config[:sign]).put(headers)
        response.print_headers if config[:headers]
        response.print
      end

    end
  end
end


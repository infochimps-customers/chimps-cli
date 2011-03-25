module Chimps
  module Commands

    # A command to issue a GET request against an index of resources
    # at Infochimps.
    class List < Chimps::Command

      include Chimps::Utils::HttpFormat
      include Chimps::Utils::ActsOnResource

      def self.default_response_fmt
        'tsv'
      end

      def self.allowed_response_fmts
        super().concat(['tsv'])
      end

      def self.allowed_resources
        %w[collection dataset source license]
      end
      
      USAGE = "usage: chimps [OPTIONS] list [RESOURCE]"
      HELP   = <<EOF

List #{default_resources_type} on Infochimps.

#{resources_listing}

Examples:

  $ chimps list                 # list all datasets
  $ chimps list --my            # list your datasets
  $ chimps list licenses        # list licenses
  $ chimps list --my sources    # list your sources
EOF

      # Issue the GET request.
      def execute!
        query_params = {}
        query_params[:skip_header] = true if config[:skip_column_names]
        Request.new(resources_path, :query_params => query_params, :sign => config[:my]).get(headers).print(config)
      end

    end
  end
end


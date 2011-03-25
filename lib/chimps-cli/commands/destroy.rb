module Chimps
  module Commands

    # A command to issue a DELETE request against a resource at
    # Infochimps.
    class Destroy < Chimps::Command

      include Chimps::Utils::ActsOnResource

      def self.allowed_models
        %w[dataset source license]
      end

      USAGE = "usage: chimps destroy [OPTIONS] [RESOURCE] ID_OR_SLUG"
      HELP   = <<EOF

Destroys a #{default_resource_type} identified by the given ID or slug.

#{resources_listing}

You can only destroy resources that you own.

Examples:

  $ chimps destroy my-crappy-dataset
  $ chimps destroy source 7837
EOF
      
      def execute!
        Request.new(resource_path, :sign => true).delete.print
      end
      
    end
  end
end


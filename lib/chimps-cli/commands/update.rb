module Chimps
  module Commands

    # A command to issue a PUT request to update a resource at
    # Infochimps.
    class Update < Chimps::Command

      include Chimps::Utils::ActsOnResource
      include Chimps::Utils::UsesParamValueData

      def self.allowed_models
        %w[dataset source license]
      end
      
      USAGE = "usage: chimps update [OPTIONS] [RESOURCE] ID_OR_SLUG [PROP=VALUE] ..."
      HELP   = <<EOF

Updates a #{default_resource_type} identified by the given ID or slug using the properties
 and values supplied.

#{how_to_input_data}
#{resources_listing}

Examples:

  $ chimps update my-awesome-dataset title='Yet More Awesome Dataset' description="It is even cooler"
  $ chimps update source my-source -d my_source.yml
EOF
      
      def execute!
        ensure_data_is_present!
        Request.new(resource_path, :body => {resource_type => data } , :sign => true).put.print
      end
      
    end
  end
end


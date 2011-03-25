module Chimps
  module Commands

    # A command to issue a POST requst to create a resource at
    # Infochimps.
    class Create < Chimps::Command

      include Chimps::Utils::ActsOnResource
      include Chimps::Utils::UsesParamValueData
      
      def self.allowed_models
        %w[dataset source license]
      end

      USAGE = "usage: chimps create [OPTIONS] [PROP=VALUE] ..."
      HELP   = <<EOF

Create a #{default_resource_type} using the properties and values supplied.

#{how_to_input_data}
#{resources_listing}

Examples:

  $ chimps create title='My Awesome Dataset' description="It is cool"
  $ chimps create source -d my_source.yml
EOF

      # Issue the POST request.
      def execute!
        ensure_data_is_present!
        Request.new(resources_path, :body => { resource_type => data}, :sign => true).post.print(:yaml => true)
      end
      
    end
  end
end


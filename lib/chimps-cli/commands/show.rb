module Chimps
  module Commands

    class Show < Chimps::Command

      include Chimps::Utils::ActsOnResource
      include Chimps::Utils::HttpFormat

      def self.default_response_fmt
        'yaml'
      end

      def self.allowed_resources
        %w[dataset collection source license user]
      end
      
      USAGE = "usage: chimps show [OPTIONS] [RESOURCE] SLUG_OR_ID"
      HELP   = <<EOF

Return a description of the #{default_resource_type} with the given
ID or or slug.

Examples:

  $ chimps show musicbrainz           # show musicbrainz dataset
  $ chimps show 11598                 # show musicbrainz dataset
  $ chimps show source musicbrainzorg # show musicbrainz.org source page
  $ chimps show user Infochimps       # show Infochimps' user page
EOF

      def execute!
        puts Chimps::Request.new(resource_path + ".#{response_fmt}").get.body
      end

    end
  end
end


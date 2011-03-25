module Chimps
  module Commands

    class Me < Chimps::Command

      include Chimps::Utils::HttpFormat

      def self.default_response_fmt
        'yaml'
      end

      USAGE = "usage: chimps me [OPTIONS]"
      HELP   = <<EOF

Show a summary of your account.

Examples:

  $ chimps me
  $ chimps me --response_format=json
EOF

      def execute!
        Chimps::Request.new("/me" + ".#{response_fmt}", :sign => true).get.print
      end

    end
  end
end


module Chimps
  module Commands

    class Test < Chimps::Command

      USAGE = "usage: chimps [OPTIONS] test"
      HELP = <<EOF

Print diagnostic information on the API credentials being used by chimps
and send a test request to Infochimps to make sure the API credentials
work.
EOF

      def execute!
        dataset_response = Chimps::Request.new("/me", :sign => true).get
        query_response   = Chimps::QueryRequest.new("soc/net/tw/trstrank", :query => {:screen_name => :infochimps}).get

        if dataset_response.error?
          puts "Could not authenticate with Infochimps Dataset API."
        else
          
          dataset_response.parse!
          username = dataset_response['user']['username']
          puts "Authenticated as user '#{username}' for Infochimps Dataset API at http://www.infochimps.com"
        end

        if query_response.error?
          puts "Could not authenticate with Infochimps Query API."
        else
          puts "Authenticated for Infochimps Query API at http://api.infochimps.com"
        end
      end

    end
  end
end


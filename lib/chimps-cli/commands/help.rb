module Chimps
  module Commands
    class Help < Chimps::Command

      USAGE = "usage: chimps help [OPTIONS] [COMMAND]"

      HELP = <<EOF
This is the Infochimps command-line client.  You can use it to search,
browse, create, edit, or delete data and metadata in the Infochimps
repository at http://www.infochimps.com.

Before you can create, edit, or delete anything you'll need to get an
Infochimps account at http://www.infochimps.org/signup.  You'll
automatically be granted an API key.

But you can still browse, search, and download (free) data
immediately.

Learn more about the Infochimps API which powers this tool at

  http://www.infochimps.com/apis

= Commands

chimps is a wrapper over the RESTful Infochimps API.  It exposes the
following core actions

  $ chimps list
  $ chimps show
  $ chimps create
  $ chimps update
  $ chimps destroy

for datasets (as well as other selected resources).  It also helps
automate the workflow of uploading and downloading data with

  $ chimps upload
  $ chimps download

You can also make queries against the Infochimps Query API with

  $ chimps query

learn more about the Infochimps Query API at
http://www.infochimps.com/api.

Finally, you can test that your system is configured properly and that
you can authenticate with Infochimps with

  $ chimps test

Get more help on a specific command with

  $ chimps help COMMAND

for any of the commands above.

= Setup

Once you have obtained an API key and secret from Infochimps, place
them in a file #{Chimps.config[:config]} in your home directory
with the following format

  ---
  # in #{Chimps.config[:config]}

  # API credentials for use with the Infochimps Dataset API
  :site:
    :key: oreeph6giedaeL3
    :secret: Queechei6cu8chiuyiig8cheg5Ahx0boolaizi1ohtarooFu1doo5ohj5ohp9eehae5hakoongahghohgoi7yeihohx1eidaeng0eaveefohchoh6WeeV1EM

  # API credentials for use on the Infochimps Query API
  :query:
    :key: zei7eeloShoah3Ce
EOF
  
      def command_name
        config.argv[1]
      end

      def command
        @command ||= Chimps::Commands.class_for(command_name).new(Chimps.config.commands[command_name][:config])
      end
      
      def execute!
        if config.argv.size > 1 && Chimps.config.command?(command_name)
          $stderr.puts command.class::USAGE
          $stderr.puts command.class::HELP
          command.config.dump_basic_help "Additional options accepted by all commands:"
        else
          $stderr.puts self.class::USAGE
          $stderr.puts self.class::HELP
        end
        Chimps.config.dump_basic_help
      end

    end
  end
end


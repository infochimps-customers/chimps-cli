module Chimps
  module Commands

    # A command to download data from Infochimps.
    class Download < Chimps::Command

      include Chimps::Utils::ActsOnResource

      USAGE = "usage: chimps download [OPTIONS] ID_OR_HANDLE"
      HELP   = <<EOF

Download a dataset identified by the given ID_OR_HANDLE.

If the dataset isn't free, you'll have to have purchased it first on
Infochimps.

Examples:

  # download to the current directory
  $ chimps download my-awesome-dataset

  # download to /tmp directory
  $ chimps download my-awesome-dataset --output=/tmp

  # save as ~/data.tar.gz (dangerous if you change the extension!)
  $ chimps download my-awesome-dataset --output=~/data.tar.gz
EOF

      def local_path
        config[:output].blank? ? Dir.pwd : File.expand_path(config[:output])
      end

      def execute!
        Chimps::Download.new(resource_identifier).download(local_path)
      end
      
    end
  end
end


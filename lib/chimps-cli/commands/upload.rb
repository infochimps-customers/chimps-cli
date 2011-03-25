module Chimps
  module Commands

    class Upload < Chimps::Command

      USAGE  = "usage: chimps upload [OPTIONS] ID_OR_SLUG [PATH|LINK] ..."
      HELP   = <<EOF

Create, modify, inspect, or submit an upload for the dataset with the
given ID or slug on Infochimps.

Check the status of the current upload for 'my-dataset'

  $ chimps upload my-dataset

If this returns a "404" then it just means that the upload does not
exist yet.  You will also see whether the upload has started or not.

Assuming the upload hasn't started, you can add files from your local
machine or links that you want Infochimps to scrape:

  $ chimps upload my-dataset /path/to/some/data.tsv
  $ chimps upload my-dataset http://www.cooldata.com/some/great/data.html
  $ chimps upload my-dataset s3://mybucket/some/open/data.xls

You can also pass more than one local file or link in each call to
`chimps upload' if you wish.

When you're ready to have Infochimps start processing the upload run

  $ chimps upload --start my-dataset

You can watch your upload's status by running

  $ chimps upload my-dataset

at any time.
EOF
      
      def upload
        return @upload if @upload
        raise CLIError.new(self.class::USAGE) if config.argv.size < 2 or config.argv[1].blank?
        @upload = Chimps::Upload.new(config.argv[1])
      end

      def objs_to_upload
        config.argv[2..-1] if config.argv.size > 2
      end

      def execute!
        case
        when config[:create]
          upload.create         # don't print b/c output is messy
        when config[:start]
          upload.start.print
        when config[:restart]
          upload.restart.print
        when config[:destroy]
          upload.destroy.print
        when objs_to_upload
          links = []
          upload.create if upload.show.error?
          objs_to_upload.each do |obj|
            if File.exist?(obj)
              tok = upload.upload_token
              upload.upload_file(obj, tok)
            else
              validate_link(obj)
              links << obj
            end
            upload.create_links(*links) unless links.empty?
          end
        else
          upload.show.print
        end
      end

      def validate_link link
        scheme = link.split("://").first
        raise UploadError.new("Infochimps only accepts links with a URI scheme (prefix) of http, https, ftp, or s3 -- you gave #{scheme}") unless ['http', 'https', 's3','ftp'].include?(scheme)
      end
      
    end
  end
end


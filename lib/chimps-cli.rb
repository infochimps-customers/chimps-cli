require 'rubygems'
ENV["BUNDLE_GEMFILE"] ||= File.expand_path('../Gemfile', File.dirname(__FILE__))
require 'bundler/setup'
require 'chimps'
require 'chimps-cli/utils'
require 'chimps-cli/commands'

# FIXME add bundler once new chimps is published

module Chimps

  autoload :Command,    'chimps-cli/commands/base'

  # Defines methods for choosing which Chimps::Command class should be
  # instantiated from the ARGV passed in on the command line.
  module CLI

    include Chimps::Commands

    # Execute the Chimps command specified on the command line.
    #
    # Will exit the Ruby process with 0 on success or 1 on an error.
    def self.execute!
      begin
        Chimps.boot!
        if command
          Chimps.config.command_settings.resolve!
          command.execute!
          return 0
        else
          $stderr.puts Chimps.config.usage
          Chimps.config.dump_help
          return 1
        end
      rescue Chimps::Error, Configliere::Error => e
        $stderr.puts e.message
        return 1
      rescue => e
        $stderr.puts("#{e.message} (#{e.class})")
        $stderr.puts(e.backtrace.join("\n"))
        return 2
      end
    end
  end
end


module Chimps

  config.use :commands

  # A namespace to hold the various commands Chimps defines.
  module Commands

    def self.class_for name
      self.instance_eval(name.to_s.capitalize)
    end

    def self.included obj
      obj.extend(ClassMethods)
    end

    module ClassMethods
      # Create a new command from the given +command_name+.  The
      # resulting command will be initialized but will not have been
      # executed.
      #
      # @return [Chimps::Command]
      def command
        return unless Chimps.config.command
        # Chimps.config.command_settings.resolve!
        Chimps::Commands.class_for(Chimps.config.command_name).new(Chimps.config.command_settings)
      end
    end

    protected
    
    def self.define_skip_column_names command
      command.define :skip_column_names, :description => "Don't print column names in output (ignored unless TSV format)", :flag => :s, :type => :boolean
    end

    def self.define_data_file command
      command.define :data, :description => "Path to a .json or .yaml file.", :flag => :d
    end

    def self.define_my command
      command.define :my, :description => "List only resources owned by you.", :flag => :m, :type => :boolean
    end

    def self.define_pretty_print command
      command.define :pretty, :description => "Pretty-print output", :flag => :p, :type => :boolean
    end

    def self.define_request_format command
      command.define :request_format, :description => "The request format (json, xml, yaml) to request from Infochimps"
    end

    def self.define_response_format command
      command.define :response_format, :description => "The response format (json, xml, yaml) to request from Infochimps"
    end

    def self.define_signable command
      command.define :sign, :description => "Sign the request", :flag => :s, :type => :boolean
    end

    def self.define_print_headers command
      command.define :headers, :description => "Print response headers", :flag => :i
    end

    def self.define_config
      
      #
      # HTTP verbs
      #
      Chimps.config.define_command :get, :description => "Send a GET request" do |command|
        # define_request_format(command)
        define_response_format(command)
        define_signable(command)
        define_print_headers(command)
      end

      Chimps.config.define_command :post, :description => "Send a POST request" do |command|
        # define_request_format(command)
        define_response_format(command)
        define_data_file(command)
        define_signable(command)
        define_print_headers(command)
      end
      
      Chimps.config.define_command :put, :description => "Send a PUT request" do |command|
        # define_request_format(command)
        define_response_format(command)
        define_data_file(command)
        define_signable(command)
        define_print_headers(command)
      end
      
      Chimps.config.define_command :delete, :description => "Send a DELETE request" do |command|
        # define_request_format(command)
        define_response_format(command)
        define_signable(command)
        define_print_headers(command)
      end
      

      #
      # Core REST actions
      #

      Chimps.config.define_command :list, :description => "List datasets, sources, users, &c." do |command|
        define_response_format(command)
        define_skip_column_names(command)
        define_my(command)
        define_pretty_print(command)
      end
      
      Chimps.config.define_command :show, :description => "Show a dataset, source, license, &c. in detail" do |command|
        define_response_format(command)
        define_response_format(command)
        define_pretty_print(command)
      end

      Chimps.config.define_command :create, :description => "Create a new dataset, source, license, &c." do |command|
        define_response_format(command)
        define_data_file(command)
      end

      Chimps.config.define_command :update, :description => "Update an existing dataset, source, license, &c." do |command|
        define_response_format(command)
        define_data_file(command)
      end

      Chimps.config.define_command :destroy, :description => "Destroy an existing dataset, source, license, &c." do |command|
        define_response_format(command)
      end

      #
      # Workflows
      #

      Chimps.config.define_command :download, :description => "Download a dataset" do |command|
        command.define :output, :description => "Path to output file (defaults to current directory)", :flag => :o, :type => String
      end

      Chimps.config.define_command :upload, :description => "Upload a dataset" do |command|
        command.define :create,  :description => "Create an empty upload", :flag => :C, :type => :boolean
        command.define :start,   :description => "Start the processing of the upload", :flag => :s, :type => :boolean
        command.define :destroy, :description => "Stop (if started) and destroy the current upload", :flag => :D, :type => :boolean
        command.define :restart, :description => "Stop the current upload (if started) and begin anew", :flag => :r, :type => :boolean
      end
      

      #
      # Other Actions
      #


      Chimps.config.define_command :me, :description => "Show your profile" do |command|
        define_response_format(command)
        define_pretty_print(command)
      end

      Chimps.config.define_command :search, :description => 'Search datasets, sources, licenses, &c.' do |command|
        define_skip_column_names(command)
        define_my(command)
        define_pretty_print(command)
        define_response_format(command)
      end

      Chimps.config.define_command :query, :description => "Get a response from the Query API" do |command|
        define_pretty_print(command)
        define_data_file(command)
      end
      
      Chimps.config.define_command :test, :description => "Test your authentication credentials with Infochimps"

      Chimps.config.define_help_command!
      
      Chimps.config.commands.keys.each do |command|
        autoload command.to_s.capitalize.to_sym, "chimps-cli/commands/#{command}"
      end
    end
    define_config

  end
end

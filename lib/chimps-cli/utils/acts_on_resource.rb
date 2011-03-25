module Chimps
  module Utils

    # Defines methods which can be included by a Chimps::Command to
    # let it interpret an optional first argument as the name of a
    # resource to act on.
    module ActsOnResource

      def self.included klass
        klass.extend(ClassMethods)
      end

      module ClassMethods
        def default_resources_type
          'datasets'
        end

        def default_resource_type
          normalize_resource_name(default_resources_type)
        end

        def allowed_resources
          %w[dataset collection source license]
        end
        
        def resources_listing
          doc = <<DOC
In addition to #{default_resources_type}, this command can operate on
other resources at Infochimps as well.  If the first
argument passed is one of

DOC
          allowed_resources.each do |resource|
            doc << "  #{resource}\n"
          end

          doc << "\nthen this command will act on that resource instead."
        end

        def normalize_resource_name string
          string.to_s.downcase.gsub(/s$/,'')
        end
        
      end

      def first_arg_is_resource_type?
        return false if config.argv.size < 2
        self.class.allowed_resources.include?(self.class.normalize_resource_name(config.argv[1]))
      end

      def resource_type
        (first_arg_is_resource_type? && self.class.normalize_resource_name(config.argv[1])) || self.class.default_resource_type
      end

      def plural_resource
        # i miss you DHH
        if resource_type[-1].chr == 'y'
          resource_type[1..-1] + 'ies'
        else
          resource_type + 's'
        end
      end

      def has_resource_identifier?
        if first_arg_is_resource_type?
          config.argv.size >= 2 && (! config.argv[1].empty?) && config.argv[2]
        else
          config.argv.size >= 1 && (! config.argv.first.empty?) && config.argv[1]
        end
      end

      def resource_identifier
        raise CLIError.new(self.class::USAGE) unless has_resource_identifier?
        first_arg_is_resource_type? ? config.argv[2] : config.argv[1]
      end
      
      def resources_path
        if config[:my]
          "/my/#{plural_resource}"
        else
          "/#{plural_resource}"
        end
      end

      def resource_path
        "#{plural_resource}/#{resource_identifier}"
      end
      
    end
  end
end

    

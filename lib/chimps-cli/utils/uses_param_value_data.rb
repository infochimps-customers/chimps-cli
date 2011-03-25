require 'yaml'
require 'json'

module Chimps
  module Utils
    module UsesParamValueData

      def self.included klass
        klass.extend(ClassMethods)
      end

      module ClassMethods
        def how_to_input_data
          <<DOC
Properties and values can be supplied directly on the command line,
from an input file, or from data streamed into STDIN, in order of
decreasing precedence.
DOC
        end
      end

      def data
        @data ||= merge_all(*(data_from_stdin + data_from_file + data_from_command_line)) || {}
      end
      
      protected

      def merge_all *objs
        objs.compact!
        return if objs.blank?   # raising an error here is left to the caller
        klasses = objs.map(&:class).uniq
        raise CLIError.new("Mismatched YAML data types -- Hashes can only be combined with Hashes, Arrays with Arrays") if klasses.size > 1
        data_type = klasses.first.new
        case data_type
        when Array
          # greater precedence at the end so iterate in order
          [].tap do |d|
            objs.each do |obj|
              d.concat(obj)
            end
          end
        when Hash
          # greater precedence at the end so iterate in order
          {}.tap do |d|
            objs.each do |obj|
              d.merge!(obj)
            end
          end
        else raise CLIError.new("Incompatible YAML data type #{data_type} -- can only combine Hashes and Arrays")
        end
      end

      def data_from_command_line
        [].tap do |d|
          config.argv.each_with_index do |arg, index|
            next unless arg =~ /^(\w+) *=(.*)$/
            name, value = $1.downcase, $2.strip
            d << { name => value } # always a hash
          end
        end
      end
            
      def data_from_file
        return [] unless config[:data]
        [].tap do |d|
          config[:data].split(',').map { |p| File.expand_path(p) }.each do |path|
            d << (path =~ /\.ya?ml$/ ? YAML.load_file(path) : JSON.parse(File.read(path)))
          end
        end
      end

      def data_from_stdin
        return [] unless $stdin.stat.size > 0
        [].tap do |d|
          begin
            YAML.load_stream($stdin).each do |document|
              d << document
            end
          rescue
            d << JSON.parse($stdin.read)
          end
        end
      end

      def ensure_data_is_present!
        raise CLIError.new(self.class::USAGE) if data.empty?
      end
      
    end
  end
end

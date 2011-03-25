module Chimps
  module Utils

    module HttpFormat

      def self.included klass
        klass.extend(ClassMethods)
      end

      module ClassMethods
        [:request, :response].each do |type|
          define_method("default_#{type}_fmt")  { 'json'            }
          define_method("allowed_#{type}_fmts") { %w[json xml yaml] }
        end
        def mime_type_for fmt
          case fmt.to_s.tr('.','').downcase.to_sym
          when :json then 'application/json'
          when :yaml then 'application/x-yaml'
          when :tsv  then 'text/tab-separated-values'
          else            'application/json' # default
          end
        end
      end

      def normalize_fmt string
        string.to_s.downcase.tr('.','')
      end

      def headers
        {
          :content_type => self.class.mime_type_for(request_fmt),
          :accept       => self.class.mime_type_for(response_fmt)
        }
      end

      [:request, :response].each do |type|
        define_method "#{type}_fmt" do
          param_name = "#{type}_format".to_sym
          if config[param_name] && self.class.send("allowed_#{type}_fmts").include?(normalize_fmt(config[param_name]))
            normalize_fmt(config[param_name])
          else
            self.class.send("default_#{type}_fmt")
          end
        end
      end

    end
  end
end

    

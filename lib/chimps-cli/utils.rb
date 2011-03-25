module Chimps

  # Raised when the user provides bad input on the command line.
  CLIError = Class.new(Error)
  
  module Utils
    autoload :ActsOnResource,     'chimps-cli/utils/acts_on_resource'
    autoload :UsesParamValueData, 'chimps-cli/utils/uses_param_value_data'
    autoload :HttpFormat,         'chimps-cli/utils/http_format'
    autoload :ExplicitPath,       'chimps-cli/utils/explicit_path'
  end

end

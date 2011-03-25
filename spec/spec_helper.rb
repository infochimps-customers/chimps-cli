CHIMPS_CLI_ROOT_DIR = File.join(File.expand_path(File.dirname(__FILE__)), '..')     unless defined? CHIMPS_CLI_ROOT_DIR
CHIMPS_CLI_SPEC_DIR = File.join(CHIMPS_CLI_ROOT_DIR, 'spec')                        unless defined? CHIMPS_CLI_SPEC_DIR
CHIMPS_CLI_LIB_DIR  = File.join(CHIMPS_CLI_ROOT_DIR, 'lib')                         unless defined? CHIMPS_CLI_LIB_DIR
$: << CHIMPS_CLI_LIB_DIR

require 'rubygems'
require 'rspec'
require 'chimps-cli'

Dir[File.dirname(__FILE__) + "/support/*.rb"].each { |path| require path }

TMP_DIR   = "/tmp/chimps_cli_test" unless defined?(TMP_DIR)

def in_tmp_dir &block
  FileUtils.mkdir_p TMP_DIR
  FileUtils.cd(TMP_DIR, &block)
end

def clean_tmp_dir!
  FileUtils.rm_rf TMP_DIR
end

def set_argv *args
  $0 = 'chimps'
  ::ARGV.replace args
  Chimps.boot!
  Chimps.config.command_settings.resolve! if Chimps::CLI.command
end

def command
  Chimps::CLI.command
end

def run
  old_stdout = $stdout
  old_stderr = $stderr
  new_stdout = StringIO.new
  new_stderr = StringIO.new
  $stdout = new_stdout
  $stderr = new_stderr
  exit_code = Chimps::CLI.execute!
  $stdout.flush
  $stderr.flush
  $stdout = old_stdout
  $stderr = old_stderr
  OpenStruct.new(:stdout => new_stdout.string, :stderr => new_stderr.string, :exit_code => exit_code)
end

def run_argv *args
  set_argv *args
  run
end

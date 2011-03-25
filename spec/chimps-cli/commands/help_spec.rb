require File.dirname(__FILE__) + '/../../spec_helper'

describe Chimps::Commands::Help do

  it "should display a default help message when called without arguments" do
    run_argv("help").stderr.should include("usage: chimps help")
  end

  it "should display a default help message when called with arguments it doesn't recognize" do
    run_argv("help", "foobar").stderr.should include("usage: chimps help")
  end
  
  it "should display help on a specific command when called with that command name" do
    run_argv("help", "show").stderr.should include("usage: chimps show")
  end

end


require File.dirname(__FILE__) + '/../../spec_helper'

describe Chimps::Commands::Get do
  it_behaves_like "a request to an explicit path"
  it_behaves_like "it can set its response format"
  
end


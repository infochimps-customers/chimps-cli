require File.dirname(__FILE__) + '/../../spec_helper'

describe Chimps::Commands::List do
  it_behaves_like "it can set its response format"
  it_behaves_like "it acts on a resource", nil
end


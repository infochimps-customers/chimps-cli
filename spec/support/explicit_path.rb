shared_examples_for 'a request to an explicit path' do

  def described_class_command_name
    described_class.to_s.split('::').last.downcase
  end

  it "should display usage when called without a path" do
    run_argv(described_class_command_name).stderr.should include("usage: chimps #{described_class_command_name}")
    run_argv(described_class_command_name).exit_code.should == 1
  end

  describe "constructing the path to send a request to" do

    it "should append a .json extension by default" do
      set_argv(described_class_command_name, "/datasets")
      command.path.should == '/datasets.json'
    end
    
    it "should an extension if given one" do
      set_argv(described_class_command_name, "/datasets.xml")
      command.path.should == '/datasets.xml'
    end

    it "should be able to extract the path when given a path with query string" do
      set_argv(described_class_command_name, "/datasets.xml?some=query&string=true")
      command.path.should == '/datasets.xml'
    end
  end

  describe "constructing the query params to send with the request" do
    it "should not set any query params by default" do
      set_argv(described_class_command_name, "/datasets.xml")
      command.query_params.should == {}
    end

    it "should detect and unescape query params when given" do
      set_argv(described_class_command_name, "/datasets.xml?withSpaces=foo+bar")
      command.query_params.should == {'withSpaces' => 'foo bar'}
    end
  end
  
end

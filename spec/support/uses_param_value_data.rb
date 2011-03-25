shared_examples_for 'it uses data' do |required_arg|

  # before do
  #   command.config[:data] = nil
  # end

  def described_class_command_name
    described_class.to_s.split('::').last.downcase
  end

  describe "directly from the command line" do
    it "should accept param, value pairs from the command line" do
      set_argv(described_class_command_name, required_arg, "foo=bar", "baz=booz")
      command.data.should == { 'foo' => 'bar', 'baz' => 'booz' }
    end
  end

  describe "from a file" do

    before do
      @data = { 'foo' => 'bar', 'baz' => { 'booz' => 'bing' } }
      end
    after  { clean_tmp_dir! }

    it "should raise an error when trying to read data from a file that doesn't exist" do
      in_tmp_dir do
        set_argv(described_class_command_name, required_arg, "--data=input.yml")
        lambda { command.data }.should raise_error()
      end
    end
    
    it "should parse data from a YAML input file" do
      in_tmp_dir do
        File.open('input.yml', 'w') { |f| f.puts @data.to_yaml }
        set_argv(described_class_command_name, required_arg, "--data=input.yml")
        command.data.should == @data
      end
    end

    it "should parse data from a JSON input file" do
      in_tmp_dir do
        File.open('input.json', 'w') { |f| f.puts @data.to_json }
        set_argv(described_class_command_name, required_arg, "--data=input.json")
        command.data.should == @data
      end
    end
  end

  describe "from stdin" do

    before do
      @data      = { 'foo' => 'bar', 'baz' => { 'booz' => 'bing' } }
      @old_stdin = $stdin
      @new_stdin = StringIO.new
      @stat      = mock("stdin stat")
      @new_stdin.stub!(:stat).and_return(@stat)
      $stdin     = @new_stdin
    end
    
    after do
      $stdin = @old_stdin
    end
    
    it "should ignore stdin if it has no data coming in" do
      @stat.stub!(:size).and_return(0)
      set_argv(described_class_command_name, required_arg)
      command.data.should == {}
    end

    # it "should read YAML data from stdin" do
    #   @new_stdin.puts @data.to_yaml
    #   @stat.stub!(:size).and_return(1)
    #   set_argv(described_class_command_name, required_arg)
    #   command.data.should == @data
    # end

    # it "should read JSON data from stdin" do
    #   @stat.stub!(:size).and_return(1)
    #   @new_stdin.puts @data.to_json
    #   set_argv(described_class_command_name, required_arg)
    #   command.data.should == @data
    # end
    
  end


  
end

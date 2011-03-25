shared_examples_for 'it can set its response format' do

  def described_class_command_name
    described_class.to_s.split('::').last.downcase
  end
  
  it "should use the default response format" do
    set_argv(described_class_command_name)
    command.response_fmt.should == described_class.default_response_fmt
  end

  it "should not accept a response format that isn't allowed" do
    set_argv(described_class_command_name, "--response_format=foobar")
    command.response_fmt.should == described_class.default_response_fmt
  end

  it "should accept a response format that is allowed" do
    response_fmt = described_class.allowed_response_fmts.first
    set_argv(described_class_command_name, "--response_format=#{response_fmt}")
    command.response_fmt.should == response_fmt
  end
  
end

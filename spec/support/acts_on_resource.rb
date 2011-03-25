shared_examples_for 'it acts on a resource' do |required_arg|

  def described_class_command_name
    described_class.to_s.split('::').last.downcase
  end

  it "should use the default resource type when not passed any arguments" do
    set_argv(described_class_command_name, required_arg)
    command.resource_type.should == described_class.default_resource_type
  end

  it "should not accept a resource type that isn't allowed" do
    set_argv(described_class_command_name, required_arg, 'foobar')
    command.resource_type.should == described_class.default_resource_type
  end

  it "should accept a resource type that is allowed" do
    set_argv(described_class_command_name, required_arg, described_class.allowed_resources.first)
    command.resource_type.should == described_class.allowed_resources.first
  end
  
end

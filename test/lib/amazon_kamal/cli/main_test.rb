require "test_helper"

class AmazonKamal::Cli::MainTest < ActiveSupport::TestCase
  test "should bootstrap hosts" do
    KAMAL.expects(:holding_lock?).returns(true)
    SSHKit::Backend::Abstract.any_instance.expects(:execute).at_least_once.returns(true)

    run_command("bootstrap").tap do |output|
      assert_match "Bootstrapping hosts...", output
      assert_match "Bootstrapping 1.1.1.1", output
      assert_match "Bootstrapping 1.1.1.2", output
    end
  end

  test "should return version" do
    assert_equal AmazonKamal::VERSION, run_command("version")
  end

  private

  def run_command(*command)
    stdouted { AmazonKamal::Cli::Main.start([ *command, "-c", "test/fixtures/deploy.yml" ]) }
  end
end

require "test_helper"

class AmazonKamal::Cli::TimersTest < ActiveSupport::TestCase
  test "should add timers" do
    SSHKit::Backend::Netssh.any_instance.expects(:upload!).twice.returns(true)
    SSHKit::Backend::Abstract.any_instance.expects(:execute).at_least_once.returns(true)
    run_command("add").tap do |output|
      assert_match "Adding systemd timers to 1.1.1.1...", output
      assert_match "Adding timer: app-cleanup-job", output
    end
  end

  test "should show timers logs" do
    SSHKit::Backend::Abstract.any_instance.expects(:capture).with(
      :journalctl,
      includes("app-cleanup-job.service")
    ).returns(true)
    assert_match "Displaying logs for systemd timers on 1.1.1.1...", run_command("logs")
  end

  test "should remove timers" do
    SSHKit::Backend::Abstract.any_instance.expects(:execute).at_least_once.returns(true)
    run_command("remove").tap do |output|
      assert_match "Removing systemd timers from 1.1.1.1...", output
      assert_match "Removing timer: app-cleanup-job", output
    end
  end

  test "should display a warning message when no timers are found" do
    run_command("remove", systemd_path: "no/files").tap do |output|
      assert_match "No timers found in no/files.", output
    end
  end

  test "should show timers" do
    SSHKit::Backend::Abstract.any_instance.expects(:capture).with(:systemctl, "list-timers").returns(true)
    assert_match "Calling systemctl list-timers on 1.1.1.1...", run_command("show")
  end

  private

  def run_command(command, systemd_path: "test/fixtures/systemd")
    stdouted { AmazonKamal::Cli::Timers.start([ command, "-c", "test/fixtures/deploy.yml", "--systemd-path", systemd_path ]) }
  end
end

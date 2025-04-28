class AmazonKamal::Cli::Main < Kamal::Cli::Base
  # include SSHKit::DSL

  desc "bootstrap", "Update packages and setup docker"
  def bootstrap
    say "Bootstrapping hosts...", :magenta

    with_lock do
      on(KAMAL.hosts) do |host|
        info("Bootstrapping #{host}")

        as "root" do
          # Update and install packages
          execute :dnf, "update -y"
          execute :dnf, "install -y docker htop git"

          # Add ssh user to docker group
          execute :usermod, "-a -G docker #{KAMAL.config.ssh.user}"

          # Start and enable docker service
          execute :systemctl, "enable --now docker"

          # Disable unnecessary services
          %w[
            amazon-ssm-agent
            gssproxy
            systemd-homed
            systemd-userdbd.socket
            systemd-userdbd
          ].each do |service|
            execute :systemctl, "disable --now #{service}"
          end
        end
      end
    end
  end

  desc "version", "Show AmazonKamal version"
  def version
    puts AmazonKamal::VERSION
  end

  desc "runner", "Manage kamal-rails-runner"
  subcommand "runner", AmazonKamal::Cli::Runner

  desc "timers", "Manage systemd timers"
  subcommand "timers", AmazonKamal::Cli::Timers
end

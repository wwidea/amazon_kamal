class AmazonKamal::Cli::Runner < Kamal::Cli::Base
  KAMAL_RAILS_RUNNER_URL = "https://raw.githubusercontent.com/wwidea/kamal-rails-runner/main/kamal-rails-runner.sh"
  KAMAL_RAILS_RUNNER_PATH = "/usr/local/bin/kamal-rails-runner"

  desc "add", "Install kamal-rails-runner"
  def add
    say "Installing kamal-rails-runner on #{KAMAL.primary_host}...", :magenta
    on(KAMAL.primary_host) do
      as "root" do
        execute :curl, "-sSL #{KAMAL_RAILS_RUNNER_URL} -o #{KAMAL_RAILS_RUNNER_PATH}"
        execute :chmod, "+x #{KAMAL_RAILS_RUNNER_PATH}"
      end
    end
  end

  desc "remove", "Remove kamal-rails-runner"
  def remove
    say "Removing kamal-rails-runner from #{KAMAL.primary_host}...", :magenta
    on(KAMAL.primary_host) do
      execute :sudo, :rm, KAMAL_RAILS_RUNNER_PATH
    end
  end
end

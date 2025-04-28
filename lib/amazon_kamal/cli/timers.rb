class AmazonKamal::Cli::Timers < Kamal::Cli::Base
  class_option :systemd_path, default: "config/systemd", desc: "Path to systemd files"

  desc "add", "Add systemd timers"
  def add
    say "Adding systemd timers to #{KAMAL.primary_host}...", :magenta

    path = options[:systemd_path]

    timers do |timer|
      say "Adding timer: #{timer}"

      on(KAMAL.primary_host) do
        # Upload files
        puts method(:upload!).source_location.inspect
        upload!("#{path}/#{timer}.timer", "/tmp")
        upload!("#{path}/#{timer}.service", "/tmp")

        as "root" do
          # Move files to systemd directory and set permissions
          execute :mv, "/tmp/#{timer}.*", "/etc/systemd/system/"
          execute :chown, "root:root", "/etc/systemd/system/#{timer}.*"
          execute :chmod, "644", "/etc/systemd/system/#{timer}.*"

          # Enable and start the timer
          execute :systemctl, "daemon-reload"
          execute :systemctl, "enable --now #{timer}.timer"
        end
      end
    end
  end

  desc "remove", "Remove systemd timers"
  def remove
    say "Removing systemd timers from #{KAMAL.primary_host}...", :magenta

    timers do |timer|
      puts "Removing timer: #{timer}"

      on(KAMAL.primary_host) do
        as "root" do
          # Stop and disable the timer
          execute :systemctl, "stop #{timer}.timer"
          execute :systemctl, "disable #{timer}.timer"

          # Remove timer files
          execute :rm, "/etc/systemd/system/#{timer}.*"

          # Reload systemd daemon
          execute :systemctl, "daemon-reload"
        end
      end
    end
  end

  desc "show", "Show timers"
  def show
    say "Calling systemctl list-timers on #{KAMAL.primary_host}...", :magenta
    on(KAMAL.primary_host) do
      puts capture(:systemctl, "list-timers")
    end
  end

  private

  def timers(&)
    timer_files = Dir.glob("#{options[:systemd_path]}/*.timer")

    if timer_files.empty?
      say "No timers found in #{options[:systemd_path]}.", :red
    else
      timer_files.each do |path|
        yield File.basename(path, ".timer")
      end
    end
  end
end

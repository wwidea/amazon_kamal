# Amazon Kamal
A set of command line tools for bootstrapping and managing Amazon Linux servers running Kamal.

## Installation
Add this line to your application’s Gemfile:
```ruby
gem "amazon_kamal"
```

And then execute:
```sh
bundle install
```

## Commands
### Bootstrap
Bootstraps an Amazon Linux 2023 server by updating packages, installing and configuring Docker, and disabling unnecessary services.

```sh
amazon-kamal bootstrap       # Update packages and setup docker
```

### Runner
Installs the **kamal-rails-runner** script into `/usr/local/bin` and makes it executable. This script simplifies running `rails runner` commands inside Kamal containers.

See [kamal-rails-runner](https://github.com/wwidea/kamal-rails-runner) for more information.

```sh
amazon-kamal runner add      # Install kamal-rails-runner
amazon-kamal runner remove   # Remove kamal-rails-runner
```

### Timers
Installs systemd services and timers located in the `config/systemd` directory on the primary Kamal server.

#### Usage
1. Create a service and corresponding timer file in `config/systemd`
2. Run **amazon-kamal timers add** to copy the files to the primary server and enable the timer
3. Run **amazon-kamal timers show** to display the timers installed on the primary server.
4. Run **amazon-kamal timers remove** to remove the timers defined in **config/systemd** from the primary server.

```sh
amazon-kamal timers add      # Add systemd timers
amazon-kamal timers remove   # Remove systemd timers
amazon-kamal timers show     # Show timers
amazon-kamal timers logs     # Show logs for systemd timers
```

#### Example systemd files
```ini
# config/systemd/app-cleanup-job.service
[Unit]
Description=Run App CleanupJob

[Service]
Type=oneshot
ExecStart=/usr/local/bin/kamal-rails-runner app "CleanupJob.perform_now"
```

```ini
# config/systemd/app-cleanup-job.timer
[Unit]
Description=Schedule App CleanupJob

[Timer]
OnCalendar=*-*-* 00:00:00
Persistent=true

[Install]
WantedBy=timers.target
```

### Version
```sh
amazon-kamal version         # Show AmazonKamal version
```

## Options
Specify the destination option to run commands on a defined Kamal destination.

```sh
# Bootstrap production servers
amazon-kamal bootstrap -d production

# Show timers on primary staging server
amazon-kamal timers show -d staging
```

## License
Amazon Kamal is available as open source under the terms of the [MIT License](https://opensource.org/license/MIT).

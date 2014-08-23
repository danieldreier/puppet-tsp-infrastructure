# Class: profile::puppet::foss::agent::noop
#
# Remove FOSS
#
class profile::puppet::foss::agent::noop {
  class { 'puppet::agent::cron':
    run_noop => true,
  }
}

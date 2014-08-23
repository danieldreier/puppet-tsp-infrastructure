# Class: profile::puppet::foss::agent::remove
#
# Remove FOSS
#
class profile::puppet::foss::agent::remove {
  class { 'puppet::agent::cron':
    enable => false,
  }->
  class { 'puppet::agent':
    ensure => absent
  }
}

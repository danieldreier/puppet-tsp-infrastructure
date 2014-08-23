# Class: profile::puppet::foss::agent::nuke
#
# Completely remove FOSS puppet and destroy the trust relationship.
#
class profile::puppet::foss::agent::nuke {

  class { 'puppet::agent::cron':
    enable => false,
  }->
  class { 'puppet::agent':
    ensure => purged,
  }

  include puppet::params

  file { $puppet::params::puppet_ssldir:
    ensure  => absent,
    recurse => true,
    force   => true,
  }

  file { $puppet::params::puppet_confdir:
    ensure  => absent,
    recurse => true,
    force   => true,
  }
}

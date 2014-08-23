# Class: profile::puppet::common::master
#
# Common to all masters, both FOSS, and Enterprise
#
class profile::puppet::common::master {

  include profile::puppet::common::reports
  include profile::puppet::common::fw

  include profile::puppet::common::master::hiera
  include profile::puppet::common::master::ci

  # JIRA OPS-313
  ssh::allowgroup  { 'puppet-users': }

  # OPS-3308
  #
  # Allow Puppet admins into the master, and allow sudo
  ssh::allowgroup  { 'puppet-admins': }
  sudo::allowgroup { 'puppet-admins': }

  class { 'r10k':
    sources => {
      'plops' => {
        'remote'  => 'git@github.com:puppetlabs/puppetlabs-modules.git',
        'basedir' => "${::settings::confdir}/environments"
      },
    },
    purgedirs => [
      "${::settings::confdir}/environments",
    ],
  }

  class { '::hiera':
    hierarchy => $profile::puppet::common::master::hiera::hierarchy,
    datadir   => "${::settings::confdir}/environments/%{environment}/extdata",
  }
}

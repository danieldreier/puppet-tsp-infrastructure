# Class: profile::puppet::common::reports
#
# Configure reporting for the Puppet masters
#
class profile::puppet::common::reports {

  $reports = [
    'puppetdb',
  ]

  ini_setting { 'reports':
    ensure  => present,
    setting => 'reports',
    value   => join($reports,','),
    section => 'master',
  }
}

# Class: profile::puppet::common::reports
#
# Configure reporting for the Puppet masters
#
class profile::puppet::common::reports {

  include profile::puppet::common::reports::hipchat

  $reports = [
    'puppetdb',
    'hipchat',
  ]

  ini_setting { 'pe_reports':
    ensure  => present,
    setting => 'reports',
    value   => join($reports,','),
    section => 'master',
  }
}

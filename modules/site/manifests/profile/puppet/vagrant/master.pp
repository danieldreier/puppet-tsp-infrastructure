# Class: site::profile::puppet::vagrant::master

class site::profile::puppet::vagrant::master (
  $ca         = hiera('ca', 'true'),
  $manifest   = hiera('manifest'),
  $modulepath = hiera('modulepath'),
  $parser     = hiera('parser', 'future'),
){

  include site::profile::puppet::master::hiera

  class { '::hiera':
    hierarchy => $site::profile::puppet::master::hiera::hierarchy,
    datadir   => '/vagrant_src/projects/infrastructure/extdata/',
  }

  class { 'puppet::server':
    parser     => $parser,
    manifest   => $manifest,
    modulepath => $modulepath,
    ca         => $ca,
  }
  ini_setting { 'ssl_client_header':
    ensure  => 'absent',
    path    => '/etc/puppet/puppet.conf',
    section => 'master',
    setting => 'ssl_client_header',
    before  => Class['puppet::server']
  }
  ini_setting { 'ssl_client_verify_header':
    ensure  => 'absent',
    path    => '/etc/puppet/puppet.conf',
    section => 'master',
    setting => 'ssl_client_verify_header',
    before  => Class['puppet::server']
  }


}

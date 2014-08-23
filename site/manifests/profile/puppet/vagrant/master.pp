# Class: profile::puppet::vagrant::master
#
# Vagrant-based FOSS server
# Lots of code duplication; needs to be refactored
#
class site::profile::puppet::vagrant::master {

  #include profile::puppet::common::reports
  include profile::puppet::common::fw

  include profile::puppet::common::master::hiera

  class { '::hiera':
    hierarchy => $profile::puppet::common::master::hiera::hierarchy,
    datadir   => "/vagrant_src/projects/infrastructure/extdata/",
  }

  #motd::register { 'Vagrant Puppet FOSS Master': }
  #include profile::server

  #include profile::puppet::common::master # breaks hiera on vagrant
  include profile::puppet::foss::fw
  include profile::puppet::foss::master::gems

  $ca         = hiera('ca')
  $manifest   = hiera('manifest')
  $modulepath = hiera('modulepath')
  $parser     = hiera('parser')

  Ini_setting {
    ensure  => present,
    path    => '/etc/puppet/puppet.conf',
    section => 'master',
  }

  ini_setting { 'ca':
    setting => 'ca',
    value   => $ca,
  }

  ini_setting { 'manifest':
    setting => 'manifest',
    value   => $manifest,
  }

  ini_setting { 'modulepath':
    setting => 'modulepath',
    value   => join($modulepath,':'),
  }

  ini_setting { 'environment':
    setting => 'environment',
    value   => 'vagrant',
  }

  ini_setting { 'parser':
    setting => 'parser',
    value   => $parser,
  }

  ini_setting { 'node_terminus':
    ensure  => absent,
    setting => 'node_terminus',
  }
}

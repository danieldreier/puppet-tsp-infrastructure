# Class: site::profile::puppet::vagrant::master
#
# Vagrant-based PE server
# Lots of code duplication; needs to be refactored
#
class site::profile::puppet::vagrant::master {

  include site::profile::puppet::reports
  include site::profile::puppet::fw

  include site::profile::puppet::master::hiera

  class { '::hiera':
    hierarchy => $site::profile::puppet::master::hiera::hierarchy,
    datadir   => "/vagrant_src/projects/infrastructure/extdata/",
  }

  #motd::register { 'Vagrant Puppet Enterprise Master': }
  include site::profile::server

  #include site::profile::puppet::master # breaks hiera on vagrant
  include site::profile::puppet::enterprise::fw
  include site::profile::puppet::enterprise::master::gems

  $ca         = hiera('pe_ca')
  $manifest   = hiera('pe_manifest')
  $modulepath = hiera('pe_modulepath')
  $parser     = hiera('pe_parser')

  #  bacula::job { "${::fqdn}-puppet-ssl":
  #    files => '/etc/puppetlabs/puppet/ssl',
  #  }

  Ini_setting {
    ensure  => present,
    path    => '/etc/puppetlabs/puppet/puppet.conf',
    section => 'master',
  }

  ini_setting { 'pe_ca':
    setting => 'ca',
    value   => $ca,
  }

  ini_setting { 'pe_manifest':
    setting => 'manifest',
    value   => $manifest,
  }

  ini_setting { 'pe_modulepath':
    setting => 'modulepath',
    value   => join($modulepath,':'),
  }

  ini_setting { 'environment':
    setting => 'environment',
    value   => 'vagrant',
  }

  ini_setting { 'pe_parser':
    setting => 'parser',
    value   => $parser,
  }

  ini_setting { 'pe_node_terminus':
    ensure  => absent,
    setting => 'node_terminus',
  }
}

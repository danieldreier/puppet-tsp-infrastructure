# Class: profile::puppet:vagrant::bootstrap_hiera
#
# Configures hiera during vagrant provisioning so that hiera data is available when puppet runs
#
class site::profile::puppet::vagrant::bootstrap_hiera {
  include profile::puppet::master::hiera
  class { '::hiera':
    hierarchy => $profile::puppet::master::hiera::hierarchy,
    datadir   => "/vagrant_src/projects/infrastructure/extdata/",
  }
}

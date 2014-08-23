# Class: profile::puppet::common::fw
#
# Manage the IPTables rules for Puppet Masters
#
class profile::puppet::common::fw {

  include profile::server::params

  $fw = $profile::server::params::fw

  if $fw {
    firewall { '500 allow HTTPS':
      port   => '443',
      proto  => 'tcp',
      action => 'accept',
    }

    firewall { '500 allow Puppet':
      port   => '8140',
      proto  => 'tcp',
      action => 'accept',
    }
  }
}

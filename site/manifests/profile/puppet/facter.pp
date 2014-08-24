# Class: profile::puppet:vagrant::bootstrap_puppetconf
#
# Configures facterlib so that facts show up without doing a facter -p
# allows facts to be used in a puppet apply
#
class site::profile::puppet::facter (
  $facterlib = hiera('facterlib', '/vagrant_src/projects/infrastructure/site/puppetlabs/lib/facter/')
  ){
  augeas { 'puppet_init_config':
    lens    => 'Shellvars.lns',
    incl    => '/etc/default/puppet',
    changes => [
      "set FACTERLIB ${facterlib}"
    ];
  }
  file_line { 'facter_bashrc':
    path => '/etc/bash.bashrc',
    line => "export FACTERLIB=${facterlib}"
  }
}

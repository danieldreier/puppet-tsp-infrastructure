# Class: site::profile::puppet::master
#
class site::profile::puppet::master {

  include profile::puppet::master::hiera

  class { 'puppet::server':
    parser => hiera('profile::puppet::master::parser', 'future')
  }

  class { 'r10k':
    sources   => {
      'plops' => {
        'remote'  => 'git@github.com:puppetlabs/puppetlabs-modules.git',
        'basedir' => "${::settings::confdir}/environments"
      },
    },
    purgedirs => [
      "${::settings::confdir}/environments",
    ],
  }

  if str2bool($::is_vagrant) {
    $datadir = '/vagrant_src/projects/infrastructure/extdata/'
  }
  else {
    $datadir = "${::settings::confdir}/environments/%{environment}/extdata"
  }
  class { '::hiera':
    hierarchy => $profile::puppet::master::hiera::hierarchy,
    datadir   => $datadir
  }
}

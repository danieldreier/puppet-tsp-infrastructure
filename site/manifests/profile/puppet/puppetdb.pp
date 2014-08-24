class profile::puppet::foss::puppetdb {

  include rsyslog
  rsyslog::snippet { 'listenonudp':
    content => "\$ModLoad imudp\n\$UDPServerRun 514"
  }

  include postgresql::server
  postgresql::role { 'puppetdb':
    password_hash => 'md5ac49217655c62cdee2b22f4d728ec844',
    login         => true,
    before        => Class['puppetdb::server'],
    require       => Class['postgresql::server'],
  } ->
  postgresql::database { 'puppetdb':
    before  => Class['puppetdb::server'],
    require => Class['postgresql::server'],
  } ->
  postgresql::database_grant { 'grant all on puppetdb to puppetdb':
    privilege => 'all',
    db        => 'puppetdb',
    role      => 'puppetdb',
    before    => Class['puppetdb::server'],
    require   => Class['postgresql::server'],
  }
  class { "puppetdb::server":
    # Enable dashboard on more than localhost
    listen_address   => '0.0.0.0',
    puppetdb_version => 'latest',
  }

  # Define our class run order.
  Class['postgresql::server'] -> Class['puppetdb::server']

  # allow puppetdb testing
  ssh::allowgroup { 'builder': }
  sudo::allowgroup { 'builder': }
}

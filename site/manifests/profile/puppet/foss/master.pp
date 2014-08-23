# Class: profile::puppet::foss::master
#
# Manage the OSS Puppet Master
#
# Includes installation, configuration, backups, and user access
#
class profile::puppet::foss::master {

  motd::register { 'Puppet FOSS Master': }

  include profile::ci::opsworker
  include profile::puppet::common::master
  include ruby::dev
  include build

  class { 'puppet::server':
    parser => hiera('profile::puppet::foss::master::parser')
  }

  bacula::job { "${::fqdn}-puppet-ssl":
    files => '/var/lib/puppet/ssl',
  }

  motd::register { "FOSS Puppet master on ${puppet::server::servertype}": }

  include puppet::reports::graphite

  # Server side generated state directory
  file { '/var/lib/puppet/moduledata':
    ensure => directory,
    owner  => 'puppet',
    mode   => '0700',
  }

  case $puppet::server::servertype {
    # Add bluepill monitoring for unicorn
    'unicorn': {
      bluepill::monitor {'unicorn-puppet':
        template => 'bluepill/bluepill-unicorn-puppet.rb.erb',
      }
    }
  }

  ##############################################################################
  # Compress and clean up old reports generated with the store report processor
  # See (#16894) why we're filling up our hard drives with this data.
  # Consider yanking the store report processors and this after 2012-11-09.
  # -- alt
  cron { 'compress_reports':
    user    => 'root',
    command => '/usr/bin/find /var/lib/puppet/reports -type f -name "*.yaml" -mtime +1 -exec gzip {} \;',
    minute  => '9',
  }
  cron { 'clean_old_reports':
    user    => 'root',
    command => '/usr/bin/find /var/lib/puppet/reports -type f -name "*.yaml.gz" -mtime +14 -exec rm {} \;',
    minute  => '0',
    hour    => '2',
  }

  if $puppet::server::ca {
    $cert_regexp = '[a-zA-Z0-9._-][a-zA-Z0-9._-]*'
    sudo::entry { 'Puppet admins: Certificate Signers':
      entry => "%puppet-admins ALL=(ALL) NOPASSWD: /usr/bin/puppet cert sign ${cert_regexp}",
    }
    sudo::entry { 'Puppet Admins: Certificate List':
      entry => "%puppet-admins ALL=(ALL) NOPASSWD: /usr/bin/puppet cert list ${cert_regexp}",
    }
    sudo::entry { 'Puppet Admins: Certificate Clean':
      entry => "%puppet-admins ALL=(ALL) NOPASSWD: /usr/bin/puppet cert clean ${cert_regexp}",
    }
    sudo::entry { 'Puppet Users: permit deploy':
      entry => "%puppet-users ALL=(ALL) NOPASSWD: /var/lib/gems/1.8/bin/r10k\n",
    }
  }

  logrotate::job { 'bluepill':
    log        => '/var/log/bluepill.log',
    options    => ['rotate 28', 'weekly', 'compress', 'compresscmd /usr/bin/xz', 'uncompresscmd /usr/bin/unxz', 'notifempty','sharedscripts'],
    postrotate => '/etc/init.d/unicorn_puppetmaster reload',
  }
}

# Class: profile::puppet:vagrant::bootstrap_puppetconf
#
# Configures modulepath so that we can do a real puppet run without an awkward --modulepath paramater that hiera knows anyway
#
class site::profile::puppet::vagrant::bootstrap_puppetconf {
  $ca         = hiera('ca')
  $manifest   = hiera('manifest')
  $modulepath = hiera('modulepath')
  $parser     = hiera('parser', 'future')

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

  ini_setting { 'basemodulepath':
    setting => 'basemodulepath',
    value   => join($modulepath,':'),
    section => 'main',
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

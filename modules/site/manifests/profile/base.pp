class site::profile::base {
  class { '::ntp': }
  $master = hiera('server')
  class { 'puppet::agent':
    server => $master
  }
}

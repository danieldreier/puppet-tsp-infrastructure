Exec {
  logoutput => 'on_failure',
  path      => '/usr/bin:/usr/sbin:/bin:/sbin',
}
case $::osfamily {
  'Debian': {
    Package { subscribe => Exec['apt_update'] }
  }
  'FreeBSD': {
    if $pkgng_enabled {
      Package { provider => pkgng }
      Cron { environment => 'PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin' }
    }
  }
  'Darwin': {
    Package { provider => macports }
  }
  'windows': {
    File { source_permissions => ignore }
  }
}

hiera_include('classes')

# site::role::puppetmaster
class site::role::puppetmaster {
  include site::profile::puppet::master
  include puppet::agent
}

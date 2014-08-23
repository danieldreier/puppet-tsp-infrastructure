# Class: profile::puppet::common::master::hiera
#
# Simply house the hierarchy variable used by all Puppet Masters.  This goes
# here only because putting this data in hiera, means that that upon lookup of
# the key, the variables inside of each item in the array are interpreted and
# do not yield the results that we need.
#
class site::profile::puppet::common::master::hiera {

  $hierarchy = [
    'vagrant/%{is_vagrant}',
    'nodes/%{domain}/%{fqdn}',
    'domains/%{domain}/groups/%{group}',
    'domains/%{domain}/stages/%{stage}',
    'domains/%{domain}',
    'groups/%{group}/%{stage}',
    'groups/%{group}',
    'location/%{whereami}',
    'os/%{osfamily}',
    'modules/%{module_name}',
    'stages/%{stage}',
    'common'
  ]
}

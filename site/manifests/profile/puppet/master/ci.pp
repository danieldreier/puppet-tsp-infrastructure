# Class: profile::puppet::common::master::ci
#
# Manage the CI access for Puppet
#
class profile::puppet::common::master::ci {

  include profile::ci::opsworker
  sudo::allowgroup { 'opsjenkins': }
}

# Class: profile::puppet::common::reports::hipchat
#
# Manage the installation and configuration of the hipchat report processor.
#
class profile::puppet::common::reports::hipchat {

  $api_key = '4fdaf681826dec737629a866524ca3'
  $room    = '333643'

  if $::is_pe == 'true' {
    class { 'puppet_hipchat':
      api_key     => $api_key,
      room        => $room,
      statuses    => [
        'changed',
        'failed',
      ],
      dashboard   => 'https://pemaster1-prod.ops.puppetlabs.net',
    }
  } else {
    class { 'puppet_hipchat':
      api_key     => $api_key,
      room        => $room,
      statuses    => [
        'changed',
        'failed',
      ],
      puppetboard => 'http://puppetboard.ops.puppetlabs.net',
    }
  }
}

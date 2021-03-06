#Primary class with options
class dnsmasq (
  $interface = 'eth0',
  $domain = undef,
  $expand_hosts = true,
  $port = '53',
  $enable_tftp = false,
  $tftp_root = '/var/lib/tftpboot',
  $dhcp_boot = 'pxelinux.0',
  $strict_order = true,
  $domain_needed = true,
  $bogus_priv = true,
  $no_negcache = false,
  $resolv_file = undef,
  $resolv_servers = undef,
) {
  include dnsmasq::params
  include concat::setup

  # Localize some variables
  $dnsmasq_package          = $dnsmasq::params::dnsmasq_package
  $dnsmasq_conffile         = $dnsmasq::params::dnsmasq_conffile
  $dnsmasq_confdir          = $dnsmasq::params::dnsmasq_confdir
  $dnsmasq_address_conffile = $dnsmasq::params::dnsmasq_address_conffile
  $dnsmasq_host_conffile    = $dnsmasq::params::dnsmasq_host_conffile
  $dnsmasq_logdir           = $dnsmasq::params::dnsmasq_logdir
  $dnsmasq_service          = $dnsmasq::params::dnsmasq_service


  package { $dnsmasq_package:
    ensure   => installed,
    provider => $::provider,
  }

  service { $dnsmasq_service:
    ensure    => running,
    name      => $dnsmasq_service,
    enable    => true,
    hasstatus => false,
    require   => Package[$dnsmasq_package],
  }

  file { $dnsmasq_confdir:
    ensure => directory,
  }

  file { $dnsmasq_conffile:
    ensure => present,
    content => template('dnsmasq/dnsmasq.conf.erb'),
    notify  => Service[$dnsmasq_service],
    require => Package[$dnsmasq_package],
  }

  concat { $dnsmasq_address_conffile:
    notify  => Service[$dnsmasq_service],
    require => Package[$dnsmasq_package],
  }

  concat { $dnsmasq_host_conffile:
    notify  => Service[$dnsmasq_service],
    require => Package[$dnsmasq_package],
  }

  if $resolv_file != undef {
    file { $resolv_file:
      content => template('dnsmasq/resolv.erb'),
      notify  => Service[$dnsmasq_service],
      require => Package[$dnsmasq_package],
    }
  }
}

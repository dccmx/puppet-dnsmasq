define dnsmasq::host (
  $ip,
  $names = [],
) {
  include dnsmasq::params

  $host_conffile = $dnsmasq::params::dnsmasq_host_conffile

  concat::fragment { "dnsmasq-host-${name}":
    order   => '00',
    target  => $host_conffile,
    content => template('dnsmasq/host.erb'),
  }

  $names.each | $aname | {
    dnsmasq::address { $aname: ip => $ip }
  }
}

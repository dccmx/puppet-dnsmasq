define dnsmasq::address (
  $ip,
) {
  include dnsmasq::params

  $address_conffile = $dnsmasq::params::dnsmasq_address_conffile

  concat::fragment { "dnsmasq-staticdns-${name}":
    order   => '00',
    target  => $address_conffile,
    content => template('dnsmasq/address.erb'),
  }

}

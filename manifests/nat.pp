class ufw::nat {

  #   augeas { "sysctl.conf":
  #   context => '/files/etc/ufw/sysctl.conf',
  #   changes => $ensure ? {
  #     present => 'set net.ipv4.ip_forward 1',
  #     default => 'rm net.ipv4.ip_forward',
  #   }
  # }

  file { "/etc/ufw/sysctl.conf":
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => 0644,
    content => template("${module_name}/sysctl.conf.erb")
  }

  file { "/etc/ufw/before.rules":
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => 0644,
    content => template("${module_name}/before.rules.erb")
  }
	$ensure = present
	augeas { "ufw-conf":
		context => '/files/etc/default/ufw',
		changes => $ensure ? {
		  present => 'set DEFAULT_FORWARD_POLICY \'"ACCEPT"\'',
		  default => 'set DEFAULT_FORWARD_POLICY \'"DROP"\'',
		},
	}

}

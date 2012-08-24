class ufw::nat($ensure = present, $filter_rules = false, $nat_rules = false) {

  augeas { "sysctl.conf":
    context => '/files/etc/sysctl.conf',
    changes => $ensure ? {
      present => 'set net.ipv4.ip_forward 1',
      default => 'rm net.ipv4.ip_forward',
    },
    require => Exec['ufw-default-deny'],
    before  => Exec['ufw-enable'],
  }

  file { "/etc/ufw/sysctl.conf":
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => 0644,
    content => template("${module_name}/sysctl.conf.erb"),
    require => Exec['ufw-default-deny'],
    before  => Exec['ufw-enable'],
  }

  file { "/etc/ufw/before.rules":
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => 0600,
    content => template("${module_name}/before.rules.erb"),
    require => Exec['ufw-default-deny'],
    before  => Exec['ufw-enable'],
  }

  augeas { "ufw-manage-builtins-conf":
    context => '/files/etc/default/ufw',
      changes => $ensure ? {
      present => 'set MANAGE_BUILTINS yes',
      default => 'set MANAGE_BUILTINS no',
    },
    require => Exec['ufw-default-deny'],
    before  => Exec['ufw-enable'],
  }

}

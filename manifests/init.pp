class ufw {

  case $::osfamily {
    debian: {
      package { 'ufw':
        ensure => present,
      }
    }
    redhat: {
      file { '/tmp/ufw-0.33_x86_64.rpm':
        ensure => present,
        source => "puppet:///modules/${module_name}/ufw-0.33_x86_64.rpm",
      }
      
      package { 'ufw':
        ensure => present,
        provider => rpm,
        source => '/tmp/ufw-0.33_x86_64.rpm',
        require => File['/tmp/ufw-0.33_x86_64.rpm'],
      }
    }
  }


  Package['ufw'] -> Exec['iptables-flush'] -> Exec['ufw-default-deny'] -> Exec['ufw-enable']

  exec { 'iptables-flush':
    command => 'iptables -F',
    unless  => 'ufw status verbose | grep "Default: deny (incoming), allow (outgoing)"',
  }

  exec { 'ufw-default-deny':
    command => 'ufw default deny',
    unless  => 'ufw status verbose | grep "Default: deny (incoming), allow (outgoing)"',
  }

  exec { 'ufw-enable':
    command => 'yes | ufw enable',
    unless  => 'ufw status | grep "Status: active"',
  }

  service { 'ufw':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    subscribe => Package['ufw'],
  }
}

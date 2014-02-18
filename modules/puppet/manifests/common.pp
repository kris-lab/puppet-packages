class puppet::common {

  helper::script {'install puppet apt sources':
    content => template('puppet/install-apt-sources.sh'),
    unless => "dpkg -l puppetlabs-release | grep '^ii '",
  }

  file {'/etc/puppet':
    ensure => directory,
    group => '0',
    owner => '0',
    mode => '0755',
  }

  file {'/etc/puppet/conf.d':
    ensure => directory,
    group => '0',
    owner => '0',
    mode => '0755',
    purge => true,
    recurse => true,
  }

  file {'/etc/puppet/conf.d/main':
    ensure => file,
    content => template('puppet/config'),
    group => '0',
    owner => '0',
    mode => '0644',
    notify => Exec['/etc/puppet/puppet.conf'],
  }

  exec {'/etc/puppet/puppet.conf':
    command => "cat /etc/puppet/conf.d/* > /etc/puppet/puppet.conf",
    path => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    refreshonly => true,
    require => File['/etc/puppet'],
  }

  ruby::gem {'deep_merge':
    ensure => present,
  }
}

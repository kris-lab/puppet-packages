class cacti::server (
  $hostname     = 'localhost',
  $port         = 80,
  $port_ssl     = 443,
  $db_host      = '%',
  $db_port      = 3306,
  $db_name      = 'cacti',
  $db_user      = 'cacti',
  $db_password  = 'dbpasswd',
  $ssl_pem      = 'sslpem',
  $ssl_key      = 'sslkey',
  $htpasswd     = 'htpasswd'
) {

  require 'snmp'
  require 'cacti'
  require 'apache2::mod::ssl'
  require 'php5::extension::snmp'

  class {'cacti::package':
  }

  mysql::user {"${db_user}@${db_host}":
    password => $db_password,
    require   => Class['cacti::package'],
  }

  file {'/etc/cacti/debian.php':
    ensure  => file,
    content => template('cacti/etc/debian.php'),
    require => Class['cacti::package'],
  }

  file {'/etc/cacti/htpasswd':
    ensure  => file,
    content => htpasswd($htpasswd),
    require => Class['cacti::package'],
  }

  file {'/etc/apache2/ssl/cacti.pem':
    ensure  => file,
    content => $ssl_cert,
    require => Class['cacti::package', 'apache2::mod::ssl'],
  }

  file {"/etc/apache2/ssl/${hostname}.pem":
    ensure => present,
    content => $ssl_pem,
    group => 'www-data',
    owner => 'www-data',
    mode => '0644',
    require => Class['apache2::mod::ssl'],
    before => Apache2::Vhost[$host],
  }

  file {"/etc/apache2/ssl/${hostname}.key":
    ensure => present,
    content => $ssl_key,
    group => 'www-data',
    owner => 'www-data',
    mode => '0644',
    require => Class['apache2::mod::ssl'],
    before => Apache2::Vhost[$host],
  }

  apache2::vhost {$hostname:
    content => template('cacti/vhost'),
  }

}

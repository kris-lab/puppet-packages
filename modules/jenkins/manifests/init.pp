class jenkins(
  $hostname,
  $port = 8080,
  $email_admin = 'root@localhost',
  $email_suffix = '@localhost',
  $num_executors = 1,
  $cluster_id = undef
) {
  
  require 'jenkins::package'
  require 'jenkins::common'
  include 'jenkins::service'

  class { 'jenkins::config::main':
    num_executors => $num_executors,
    email_admin   => $email_admin,
    email_suffix  => $email_suffix,
    hostname      => $hostname,
    port          => $port,
  }
  include 'jenkins::config::credentials'

  file { '/var/lib/jenkins/plugins':
    ensure => 'directory',
    owner  => 'jenkins',
    group  => 'nogroup',
    mode   => '0755',
  }

  file { '/var/lib/jenkins/jobs':
    ensure => 'directory',
    owner  => 'jenkins',
    group  => 'nogroup',
    mode   => '0755',
  }

  file { '/var/lib/jenkins/installPlugin.sh':
    ensure  => file,
    content => template("${module_name}/installPlugin.sh.erb"),
    owner   => 'jenkins',
    group   => 'jenkins',
    mode    => '0755',
  }

  file { '/etc/default/jenkins':
    ensure  => file,
    content => template("${module_name}/default"),
    owner   => '0',
    group   => '0',
    mode    => '0644',
    notify  => Service['jenkins'],
  }

  if $cluster_id != undef {
    ssh::auth::id { "jenkins@cluster-${cluster_id}":
      user => 'jenkins',
    }

    $ssh_keys = generate_sshkey("jenkins@cluster-${cluster_id}")

    jenkins::config::credential::ssh{ 'cluster-credential':
      username    => 'jenkins',
      private_key => $ssh_keys['private']
    }

    Jenkins::Config::Slave <<| cluster_id == $cluster_id |>>
  }

}

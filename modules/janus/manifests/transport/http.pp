define janus::transport::http(
  $origin = false,
  $threads = 'unlimited',
  $http = 'yes',
  $http_base_path = '/janus',
  $port = 8300,
  $https = 'no',
  $secure_port = 8301,
  $acl = undef,
  $admin_base_path = '/admin',
  $admin_threads = 'unlimited',
  $admin_http = 'no',
  $admin_port = 8302,
  $admin_https = 'no',
  $admin_secure_port = 8303,
  $admin_acl = '127.'
) {

  $instance_name = $origin ? {
    true     => 'janus',
    default  => "janus_${title}",
  }

  $base_dir = $origin ? {
    true    => '',
    default => "/opt/janus-cluster/${title}",
  }

  file { "${base_dir}/usr/lib/janus/transports/libjanus_http.so":
    ensure    => link,
    target    => '/usr/lib/janus/transports/libjanus_http.so',
    notify    => Service[$instance_name],
    require   =>  Exec["Create ${base_dir} dirs for ${title}"],
  }

  file { "${base_dir}/etc/janus/janus.transport.http.cfg":
    ensure    => 'present',
    content   => template("${module_name}/transport/http.cfg"),
    owner     => '0',
    group     => '0',
    mode      => '0644',
    notify    => Service[$instance_name],
    require   =>  Exec["Create ${base_dir} dirs for ${title}"],
  }
}

node default {

  file { '/tmp/repo':
    ensure => directory,
  }
  ->

  exec { 'create git repo':
    command => 'git init',
    path    => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    cwd     => '/tmp/repo',
  }
  ->

  exec { 'tag 1':
    command => 'touch file1 && git add -A && git commit -m "commit1" && git tag "tag1"',
    path    => ['/usr/local/sbin', '/usr/local/bin', '/usr/sbin', '/usr/bin', '/sbin', '/bin'],
    cwd     => '/tmp/repo',
  }

}

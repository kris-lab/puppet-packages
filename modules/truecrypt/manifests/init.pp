class truecrypt(
  $version = '7.2'
) {

  require 'apt'
  require 'build'

  $libwxbase_package_name = ($::facts['lsbdistcodename'] == 'wheezy') ? { true => 'libwxbase2.8-dev', default => 'libwxbase3.0-dev' }

  package { [
    'libfuse-dev',
    'nasm',
    'libpkcs11-helper1-dev',
    $libwxbase_package_name,
    'pkg-config'
  ]:
    provider => 'apt',
  }
  ->

  helper::script { 'install truecrypt':
    content     => template("${module_name}/install.sh"),
    unless      => "truecrypt --version | grep -e 'TrueCrypt ${version}$'",
    timeout     => 900,
  }
}

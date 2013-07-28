class monit ($emailTo = 'root', $emailFrom = 'root', $allowedHosts = []) {

	file { '/etc/default/monit':
		content => template('monit/default'),
		ensure => present,
		group => '0', owner => '0', mode => '0644',
		notify => Service['monit'],
	}
	->

	file { '/etc/monit':
		ensure => directory,
		group => '0', owner => '0', mode => '0755',
	}
	->

	file { '/etc/monit/monitrc':
		content => template('monit/monitrc'),
		ensure => present,
		group => '0', owner => '0', mode => '0600',
		notify => Service['monit'],
	}
	->

	package {'monit':
		ensure => present,
	}
	->

	service {'monit':
		hasstatus => false,
	}
}
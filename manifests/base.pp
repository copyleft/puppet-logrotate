# Internal: Install logrotate and configure it to read from /etc/logrotate.d
#
# Examples
#
#   include logrotate::base
class logrotate::base {
  $group = $kernel ? {
    'FreeBSD' => 'wheel',
    default => 'root'
  }

  package { 'logrotate':
    ensure => latest,
  }

  File {
    owner   => 'root',
    group   => $group,
    require => Package['logrotate'],
  }

  file {
    '/etc/logrotate.conf':
      ensure  => file,
      mode    => '0444',
      group   => $group,
      source  => 'puppet:///modules/logrotate/etc/logrotate.conf';
    '/etc/logrotate.d':
      ensure  => directory,
      mode    => '0755',
      group   => $group;
    '/etc/cron.daily/logrotate':
      ensure  => file,
      mode    => '0555',
      group   => $group,
      source  => 'puppet:///modules/logrotate/etc/cron.daily/logrotate';
  }

  case $::osfamily {
    'Debian': {
      include logrotate::defaults::debian
    }
    'RedHat': {
      include logrotate::defaults::redhat
    }
    'SuSE': {
      include logrotate::defaults::suse
    }
    'FreeBSD': {
      include logrotate::defaults::freebsd
    }
    
    default: { }
  }
}

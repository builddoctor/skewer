class apache::install {
  package {
    'apache2': ensure => present
  }
  file {
    '/var/www/index.html':
      ensure => present,
      content => 'Puppet Run Success',
      require => Package['apache2'];
  }
  service {
    'apache2':
      ensure => running,
      require => Package['apache2'];
  }
}
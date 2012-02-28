class puppet::munge {
  group {
    'puppet': ensure => present
  }
}
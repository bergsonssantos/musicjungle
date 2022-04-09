exec { "apt-update":
  command => "/usr/bin/apt update"
}

package { ["openjdk-8-jre", "tomcat9"]:
  ensure => installed,
  require => Exec["apt-update"]
}

exec { "apt-update":
  command => "/usr/bin/apt update"
}

package { ["openjdk-8-jre-headless", "tomcat9", "mysql-server"]:
  ensure => installed,
  require => Exec["apt-update"]
}

service { "tomcat9":
  ensure => running,
  enable => true,
  hasstatus => true,
  hasrestart => true,
  require => Package["tomcat9"]
}

service { "mysql":
  ensure => running,
  enable => true,
  hasstatus => true,
  hasrestart => true,
  require => Package["mysql-server"]
}

exec { "musicjungle-create-db":
  command => "mysqladmin -u root create musicjungle",
  path => "/usr/bin",
  unless => "mysql -u root musicjungle",
  require => Service["mysql"]
}

exec { "mysql-password":
  command => "mysql -u root -e \"CREATE USER 'musicjungle'@'localhost' IDENTIFIED BY 'minhasenha';\" &&  mysql -u root -e \"GRANT ALL PRIVILEGES ON *.* TO 'musicjungle'@'localhost' WITH GRANT OPTION;\" musicjungle",
  path => "/usr/bin",
  unless => "mysql -umusicjungle -pminhasenha musicjungle",
  require => Exec["musicjungle-create-db"]
}

file { "/var/lib/tomcat9/webapps/vraptor-musicjungle.war":
  source => "/vagrant/manifests/vraptor-musicjungle.war",
  #owner => "tomcat",
  #group => "tomcat",
  #mode => "0644",
  require => Package["tomcat9"],
  #notify => Service["tomcat9"]
}

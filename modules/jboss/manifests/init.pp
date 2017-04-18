class jboss{

  $service = 'jboss'
  $jboss = '/opt/jboss-as-7.1.1'
  $java = '1.7.0'


  package { 'java':
    name => "java-$java-openjdk",
    ensure => installed,
    }

  file { $jboss:
      ensure  => directory,
      source  => 'puppet:///modules/jboss/jboss-as-7.1.1',
      path    => $jboss,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      recurse => 'remote',
      require => Package['java']
      }
      
  file { '/etc/init.d/jboss':
	content => template('jboss/jboss.erb'),
	owner   => root,
	group   => root,
	mode    => '0755',
	ensure  => file,
	notify  => Service[$service]
	}
	
  service { $service:
      ensure => 'running',
      enable => true,
      require => Exec['Register_init']
    }

  exec { 'Register_init':
      command => "chkconfig --add /etc/init.d/jboss",
      path => ['/usr/bin', '/usr/sbin',],
  }
      
}

class deploy{

  $app_url = "http://www.cumulogic.com/download/Apps/testweb.zip" 
  $app_file = "/opt/jboss-as-7.1.1/standalone/deployments/testweb.zip"
  $app_folder = "/opt/jboss-as-7.1.1/standalone/deployments/"

  package { 'unzip':
    ensure => installed,
    }

  file { $app_file:
      ensure  => file,
      source  => $app_url,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      }

  exec {'unzip':
      command => "unzip -j ${app_file} -d ${app_folder}",
      path => ['/usr/bin', '/usr/sbin',],
      creates => "${app_folder}/testweb.war",
	}
}

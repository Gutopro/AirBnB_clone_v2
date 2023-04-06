# setting up the web servers for the deployment of web_static
class web_static {
  package { 'nginx':
    ensure => installed,
  }

  file { '/data/web_static/shared':
    ensure => directory,
    owner  => 'ubuntu',
    group  => 'ubuntu',
    mode   => '0775',
  }

  file { '/data/web_static/releases/test/':
    ensure => directory,
    owner  => 'ubuntu',
    group  => 'ubuntu',
    mode   => '0775',
  }

  file { '/data/web_static/releases/test/index.html':
    ensure => file,
    owner  => 'ubuntu',
    group  => 'ubuntu',
    mode   => '0644',
    content => '
      <html>
        <head>
        </head>
        <body>
          Holberton School
        </body>
      </html>
    ',
  }

  file { '/data/web_static/current':
    ensure => 'link',
    target => '/data/web_static/releases/test/',
  }

  service { 'nginx':
    ensure  => running,
    enable  => true,
    require => Package['nginx'],
  }

  file_line { 'add_hbnb_static_location':
    path => '/etc/nginx/sites-available/default',
    line => 'location /hbnb_static {',
    after => 'server {',
  }

  file_line { 'add_alias_to_hbnb_static_location':
    path => '/etc/nginx/sites-available/default',
    line => 'alias /data/web_static/current;',
    after => 'location /hbnb_static {',
  }

  exec { 'restart_nginx':
    command     => '/etc/init.d/nginx restart',
    refreshonly => true,
    subscribe   => [
      File_line['add_hbnb_static_location'],
      File_line['add_alias_to_hbnb_static_location'],
    ],
  }
}

include web_static

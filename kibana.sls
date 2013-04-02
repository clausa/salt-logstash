git:
  pkg:
    - installed

libapache2-mod-passenger:
  pkg:
    - installed

ruby:
  pkg: 
    - installed

rubygems:
  pkg:
    - installed

ruby-bundler:
  pkg:
    - installed

https://github.com/rashidkpc/Kibana.git:
  git.latest:
    - target: /srv/kibana
    - require:
      - pkg: git

/etc/apache2/sites-available/logstash:
  file:
    - managed
    - source: salt://files/logstash-apache2.conf
    - template: jinja

/usr/sbin/a2dissite 000-default:
  cmd:
    - run
    - onlyif: ls -l /etc/apache2/sites-enabled | grep default
    - require:
      - pkg: libapache2-mod-passenger

/usr/sbin/a2ensite logstash:
  cmd:
    - run
    - unless: ls -l /etc/apache2/sites-enabled | grep logstash
    - require:
      - file: /etc/apache2/sites-available/logstash
      - pkg: libapache2-mod-passenger

apache2:
  service:
    - running
    - watch:
      - file: /etc/apache2/sites-available/logstash

bundle install:
  cmd:
    - run
    - unless: gem list | grep sinatra
    - cwd: /srv/kibana
    - require:
      - pkg: rubygems
      - pkg: ruby-bundler
      - git: https://github.com/rashidkpc/Kibana.git

openjdk-7-jre-headless:
  pkg:
    - installed

libtokyocabinet8:
  pkg:
    - installed

/var/cache/apt/archives/grok_1.20120204.1_amd64.deb:
  file:
    - managed
    - source: salt://files/grok_1.20120204.1_amd64.deb

dpkg -i /var/cache/apt/archives/grok_1.20120204.1_amd64.deb:
  cmd:
    - run
    - unless: dpkg --get-selections | grep grok | grep install
    - require:
      - file: /var/cache/apt/archives/grok_1.20120204.1_amd64.deb
      - pkg: libtokyocabinet8

/var/cache/apt/archives/logstash_1.1.1_all.deb:
  file:
    - managed
    - source: salt://files/logstash_1.1.1_all.deb

dpkg -i /var/cache/apt/archives/logstash_1.1.1_all.deb:
  cmd:
    - run
    - unless: dpkg --get-selections | grep logstash | grep install
    - require:
      - file: /var/cache/apt/archives/logstash_1.1.1_all.deb
      - pkg: openjdk-7-jre-headless
      - pkg: libtokyocabinet8

/usr/share/logstash/logstash-1.1.1-monolithic.jar:
  file.managed:
    - user: root
    - group: root
    - mode: 664

/srv/logstash/:
  file.directory:
    - makedirs: True
    - user: logstash
    - group: logstash
    - require: 
      - user: logstash

/srv/logstash/log/:
  file.directory:
    - makedirs: True
    - user: logstash
    - group: logstash
    - require:
      - user: logstash

/etc/logstash/:
  file.directory:
    - makedirs: True
    - user: root
    - group: root

/etc/logstash/logstash.conf:
  file:
    - managed
    - source: salt://files/logstash.conf
    - template: jinja

/etc/init/logstash.conf:
  file:
    - managed
    - source: salt://files/logstash.init

logstash:
  service:
    - running
    - watch:
      - file: /etc/init/logstash.conf
      - file: /etc/logstash/logstash.conf
    - require: 
      - user: logstash
  user:
    - present
    - system: True





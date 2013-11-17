openjdk-7-jre-headless:
  pkg:
    - installed

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

/usr/share/logstash/:
  file.directory:
    - makedirs: True
    - user: root
    - group: root

logstash:
  file.managed:
    - source: https://logstash.objects.dreamhost.com/release/logstash-1.1.9-monolithic.jar
    - source_hash: md5=70addd3ccd37e796f473fe5647c31126
    - name: /usr/share/logstash/logstash-latest-monolithic.jar
    - user: root
    - group: root
    - mode: 664
    - require:
      - pkg: openjdk-7-jre-headless
  service:
    - running
    - watch:
      - file: /etc/init/logstash.conf
      - file: /etc/logstash/logstash.conf
    - require: 
      - user: logstash
  user:
    - present
    - fullname: Logstash User
    - home: /srv/logstash
    - system: true

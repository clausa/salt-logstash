rsyslog:
  pkg:
    - installed
  service:
    - running
    - watch:
      - file: /etc/rsyslog.d/logstash.conf

/etc/rsyslog.d/logstash.conf:
  file:
    - managed
    - source: salt://files/rsyslog-logstash.conf
    - require:
      - pkg: rsyslog

/var/cache/rsyslog:
  file:
    - directory
    - user: syslog
    - group: root
    - mode: 755
    - makedirs: True

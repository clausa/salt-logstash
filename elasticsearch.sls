openjdk-7-jre-headless:
  pkg:
    - installed

/var/cache/apt/archives/elasticsearch-0.19.10.deb:
  file:
    - managed
    - source: salt://files/elasticsearch-0.19.10.deb

dpkg -i /var/cache/apt/archives/elasticsearch-0.19.10.deb:
  cmd:
    - run
    - unless: service elasticsearch status
    - require:
      - file: /var/cache/apt/archives/elasticsearch-0.19.10.deb
      - pkg: openjdk-7-jre-headless

/etc/default/elasticsearch:
  file:
    - sed
    - before: '#ES_HEAP_SIZE=2g'
    - after: ES_HEAP_SIZE={{ grains['mem_total']-2000 }}m
    - require:
      - cmd: dpkg -i /var/cache/apt/archives/elasticsearch-0.19.10.deb

/etc/elasticsearch/elasticsearch.yml:
  file:
    - unless: grep "ElasticSearch Configuration Example" /etc/elasticsearch/elasticsearch.yml
    - managed
    - source: salt://files/elasticsearch.yml
    - template: jinja
    - require:
      - cmd: dpkg -i /var/cache/apt/archives/elasticsearch-0.19.10.deb

elasticsearch:
  service:
    - running
    - watch:
      - file: /etc/elasticsearch/elasticsearch.yml
      - file: /etc/security/limits.conf

/usr/share/elasticsearch/bin/plugin -install karmi/elasticsearch-paramedic:
  cmd:
    - run
    - unless: curl -s http://localhost:9200/_plugin/paramedic/index.html | grep Paramedic
    - require:
      - cmd: dpkg -i /var/cache/apt/archives/elasticsearch-0.19.10.deb

/etc/pam.d/su:
  file:
    - sed
    - before: '# session    required   pam_limits.so'
    - after: 'session    required   pam_limits.so'

/etc/security/limits.conf:
  file:
    - append
    - text:
      - elasticsearch soft nofile 60000
      - elasticsearch hard nofile 60000


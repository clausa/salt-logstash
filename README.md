salt-logstash
=============

salt state definitions for installing logstash, elasticsearch, kibana and rsyslog

```shell
wget -O - http://bootstrap.saltstack.org | sudo sh
sudo git clone https://github.com/clausa/salt-logstash.git /srv/salt
sudo salt-call --local state.highstate
```

$BROWSER http://localhost/


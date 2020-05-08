{% from "sensu/pillar_map.jinja" import sensu with context %}
{% from "sensu/service_map.jinja" import services with context %}

include:
  - sensu
  - sensu.rabbitmq_conf

{% if grains['os'] == 'CentOS' %}
install_yum_versionlock:
  pkg.installed:
    - name: yum-plugin-versionlock

install_gems_compilling:
  pkg.installed:
    - name: gcc-c++
{% endif %}

install_sensu_client:
  pkg.installed:
    - name: sensu
    - version: 1:0.26.5-2
    - hold: True
    - require:
      - pkgrepo: sensu

/etc/sensu/conf.d/client.json:
  file.managed:
    - source: salt://sensu/files/client.json
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: sensu

/etc/sensu/plugins:
  file.recurse:
    - source: salt://sensu/files/plugins
    - file_mode: 555
    - require:
      - pkg: sensu
    - require_in:
      - service: sensu-client
    - watch_in:
      - service: sensu-client

sensu-client:
  service.running:
    - enable: True
    - require:
      - file: /etc/sensu/conf.d/client.json
      - file: /etc/sensu/conf.d/rabbitmq.json
    - watch:
      - file: /etc/sensu/conf.d/*

{% if sensu.client.embedded_ruby %}
/etc/default/sensu:
  file.replace:
    - pattern: 'EMBEDDED_RUBY=false'
    - repl: 'EMBEDDED_RUBY=true'
    - watch_in:
      - service: sensu-client
{% endif %}

{% if sensu.client.nagios_plugins %}
{{ services.nagios_plugins }}:
  pkg:
    - installed
    - require_in:
      - service: sensu-client
{% endif %}

{% if grains['os'] == 'CentOS' %}
install_yum_versionlock:
  pkg.installed:
    - name: yum-plugin-versionlock
{% endif %}

install_sensu_client:
  pkg.installed:
    - name:
    - version: 1:0.20.3-1
    - hold: True
    - require:
      - pkgrepo: sensu


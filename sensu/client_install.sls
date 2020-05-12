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
    {% if  grains['os'] == 'CentOS' %}
    - version: 1:0.26.5-2
    {% elif grains['os'] == 'Debian' %}
    - version: 0.26.5-2
    {% endif %}
    - hold: True
    - require:
      - pkgrepo: sensu

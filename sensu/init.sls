{% if grains['os_family'] == 'Debian' %}
python-apt:
  pkg:
    - installed
    - require_in:
      - pkgrepo: sensu
{% endif %}

sensu:
  pkgrepo.managed:
    - humanname: Sensu Repository
    {% if grains['os_family'] == 'Debian' %}
    - name: deb http://builder.zen.onestic.com/debian/sensu/ stretch main
    - file: /etc/apt/sources.list.d/sensu.list
    - key_url: http://builder.zen.onestic.com/debian/sensu/onestic-sensu-keyring.gpg
    {% elif grains['os_family'] == 'RedHat' %}
    - baseurl: http://builder.zen.onestic.com/sensu/$releasever/$basearch/
    - gpgcheck: 0
    - enabled: 1
    {% endif %}

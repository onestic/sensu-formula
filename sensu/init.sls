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
    - name: deb https://eol-repositories.sensuapp.org/apt sensu main
    - file: /etc/apt/sources.list.d/sensu.list
    - key_url: http://eol-repositories.sensuapp.org/apt/pubkey.gpg
    {% elif grains['os_family'] == 'RedHat' %}
    - baseurl: https://eol-repositories.sensuapp.org/yum/$releasever/$basearch/
    - gpgcheck: 0
    - enabled: 1
    {% endif %}

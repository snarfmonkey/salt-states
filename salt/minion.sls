{% from "salt/map.jinja" import salt_settings with context %}

salt-minion:
{% if salt_settings.install_packages %}
  pkg.installed:
    - name: {{ salt_settings.salt_minion }}
{% endif %}
  file.managed:
    - name: {{ salt_settings.config_path }}/minion.d/flightstats.conf
    - template: jinja
    - source: salt://{{ slspath }}/files/minion.d/flightstats.conf.jinja
    - clean: {{ salt_settings.clean_config_d_dir }}
  service.running:
    - enable: True
    - name: {{ salt_settings.minion_service }}
    - watch:
{% if salt_settings.install_packages %}
      - pkg: salt-minion
{% endif %}
      - file: salt-minion
      - file: remove-old-minion-conf-file

# clean up old _defaults.conf file if they have it around
remove-old-minion-conf-file:
  file.absent:
    - name: /etc/salt/minion.d/_defaults.conf

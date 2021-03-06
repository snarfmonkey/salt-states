znc_pkg:
  pkg.installed:
    - name: znc

znc_user:
  user.present:
    - name: znc

znc_conf:
  file.managed:
    - name: /home/znc/.znc/configs/znc.conf
    - source: salt://znc/files/znc.conf.jinja
    - template: jinja
    - user: znc
    - group: znc
    - require: [user: znc_user]

znc_init:
  file.managed:
{%- if grains['init'] == 'systemd' %}
    - name: /lib/systemd/system/znc.service
    - source: salt://znc/files/systemd-znc.service.jinja
{%- else %}
    - name: /etc/init/znc.conf
    - source: salt://znc/files/init-znc.conf.jinja
{%- endif %}
    - template: jinja
    - require: [user: znc_user]

znc_service:
  service.running:
    - name: znc
    - require:
      - pkg: znc_pkg
      - user: znc_user
      - file: znc_init
    - watch: [file: znc_conf]

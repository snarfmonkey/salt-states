caddy_set_file_limits:
  file.managed:
    - name: /etc/security/limits.d/caddy.conf
    - contents: |
        #<domain>      <type>  <item>         <value>
        caddy            soft    nofile          4096
        caddy            hard    nofile          4096

caddy_init:
  file.managed:
{%- if grains['init'] == 'systemd' %}
    - name: /lib/systemd/system/caddy.service
    - source: salt://caddy/files/systemd-caddy.service.jinja
{%- else %}
    - name: /etc/init/caddy
    - source: salt://caddy/files/init-caddy.conf.jinja
{%- endif %}
    - template: jinja
    - require: [file: caddy_config_js]

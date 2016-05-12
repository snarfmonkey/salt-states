ghost_deps:
  pkg.installed:
    - pkgs: 
      - nodejs
      - npm

ghost_nodejs_node_symlink:
  alternatives.install:
    - name: node
    - link: /usr/bin/node
    - path: /usr/bin/nodejs
    - priority: 30
    - require: [pkg: ghost_deps]

ghost_user:
  user.present:
    - name: ghost
    - require: [pkg: ghost_deps]

ghost_archive:
  archive.extracted:
    - name: /var/www/ghost
    - source: https://ghost.org/zip/ghost-0.7.8.zip
    - source_hash: md5=3e912f9df7a4de7701fd0022ba7ef7da
    - archive_format: zip
    - user: ghost
    - require: [user: ghost_user]

ghost_install:
  cmd.run:
    - name: npm install --production
    - cwd: /var/www/ghost
    - user: ghost
    - require: 
      - pkg: ghost_deps
      - user: ghost_user
    - onchanges: [archive: ghost_archive]

ghost_config_js:
  file.managed:
    - name: /var/www/ghost/config.js
    - source: salt://ghost/files/config.js.jinja
    - user: ghost
    - group: ghost
    - require:
      - cmd: ghost_install
      - archive: ghost_archive
    - template: jinja

ghost_init:
  file.managed:
{%- if grains['init'] == 'systemd' %}
    - name: /lib/systemd/system/ghost.service
    - source: salt://ghost/files/systemd-ghost.service.jinja
{%- else %}
    - name: /etc/init/ghost
    - source: salt://ghost/files/init-ghost.conf.jinja
{%- endif %}
    - template: jinja
    - require: [file: ghost_config_js]

ghost_run:
  service.enabled:
    - name: ghost
    - reload: True
    - require:
      - file: ghost_init
    - watch: [file: ghost_config_js]

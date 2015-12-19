{% import_yaml "nodejs/defaults.yaml" as defaults %}
{% set nodejs = salt['pillar.get']('nodejs', default=defaults.nodejs) %}
nodejs_ppa:
  pkgrepo.managed:
    - humanname: {{ nodejs.humanname }}
    - name: {{ nodejs.repo }} {{ grains['oscodename'] }} main
    - dist: {{ grains['oscodename'] }}
    - file: /etc/apt/sources.list.d/{{ nodejs.listfile }}
{% if nodejs.key_url is defined %}
    - key_url: {{ nodejs.key_url }}
{% else %}
    - keyid: '{{ nodejs.keyid }}'
    - keyserver: {{ nodejs.keyserver }}
{% endif %}

nodejs_install:
  pkg.installed:
    - name: nodejs
    - require: [pkgrepo: nodejs_ppa]

nodejs-node-symlink:
  alternatives.install:
    - name: node
    - link: /usr/bin/node
    - path: /usr/bin/nodejs
    - priority: 30
    - require: [pkg: nodejs_install]

{% set allowed_tcp_ports salt['pillar.get']('allowed_tcp_ports', []) -%}
include:
  - base.sshd

ufw_package:
  pkg.installed:
    - name: ufw

ufw_rules:
  cmd.run:
    - name: ufw allow proto tcp from any to any port {% for port in allowed_tcp_ports -%} {{ port }} {%- if not loop.last %},{% endif %}{% endfor %}
    - require: [sls: base.sshd]

ufw_enable:
  cmd.run:
    - name: ufw enable
    - require: [cmd: ufw_rules]

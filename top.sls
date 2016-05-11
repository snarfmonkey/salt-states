{%- set roles = salt['grains.get']('roles', '') %}
base:
  '*':
    - base
    {%- for role in roles %}
    - {{ role }}
    {%- endfor %}

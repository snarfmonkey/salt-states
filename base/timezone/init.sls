{# See tz_options.yaml for accepted values for timezone grains #}
{% import_yaml "base/timezone/tz_options.yaml" as tz_options %}
{% if grains['timezone'] is defined %}
{% set timezone = grains['timezone'] %}
{% else %}
{% set timezone = 'UTC' %}
{% endif %}
{% if timezone in tz_options %}
set_timezone:
  timezone.system:
    - name: {{ timezone }}
    - utc: True

restart_timezone_after_change:
  service.running:
    - name: rsyslog
    - watch: [timezone: set_timezone]
{% endif %}

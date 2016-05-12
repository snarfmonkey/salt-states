sshd_config:
  file.managed:
    - name: /etc/ssh/sshd_config
    - source: salt://base/sshd/files/sshd_config.jinja
    - template: jinja

sshd_service_reload:
  service.enabled:
    - name: ssh
    - onchanges: [file: sshd_config]

base_packages:
  pkg.installed:
    - pkgs:
      - git
      - htop
      - sysstat

network_security:
  file.append:
    - name: /etc/sysctl.d/10-network-security.conf
    - source: salt://base/files/10-network-security.conf.jinja
    - template: jinja

network_security_restart:
  service.running:
    - name: procps
    - watch: [file: network_security]

master-conf-file:
  file.managed:
    - name: /etc/salt/master.d/gitfs.conf
    - source: salt://salt/files/master.d/gitfs.conf

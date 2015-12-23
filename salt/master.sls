master-conf-file:
  file.managed:
    - name: /etc/salt/master
    - source: salt://salt/files/master.d/gitfs.conf

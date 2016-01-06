include:
  - apt.internal

salt-minion-new-version:
  cmd.run:
    - name: apt-get -y -o Dpkg::Options::="--force-confold" install salt-minion

salt-minion-config:
  file.managed:
    - name: /etc/salt/minion.d/flightstats.conf
    - template: jinja
    - source: salt://salt/files/minion.d/flightstats.conf.jinja
    - watch: [cmd: salt-minion-new-version]

salt-minion-restart:
  cmd.run:
    - name: service salt-minion restart
    - onchanges: [file: salt-minion-config]

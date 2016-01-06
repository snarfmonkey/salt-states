saltmaster_pki_dir:
  file.directory:
    - name: /etc/salt/pki/master
    - user: root
    - group: root
    - mode: 0700
    
saltmaster_pki_key:
  file.managed:
    - name: /etc/salt/pki/master/master.pem
    - contents_pillar: saltmaster_pki_key
    - user: root
    - group: root
    - mode: 0600
    - require: [file: saltmaster_pki_dir]

saltmaster_pki_pub:
  file.managed:
    - name: /etc/salt/pki/master/master.pub
    - contents_pillar: saltmaster_pki_pub
    - user: root
    - group: root
    - mode: 0644
    - require: [file: saltmaster_pki_dir]

saltmaster_restart:
  service.running:
    - name: salt-master
    - watch: [file: saltmaster_pki_pub]

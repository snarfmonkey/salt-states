ssh_config_dir:
  file.directory:
    - name: /root/.ssh
    - user: root
    - group: root
    - mode: 700

ssh_config_file:
  file.managed:
    - name: /root/.ssh/config
    - user: root
    - group: root
    - mode: 600
    - require:
      - file: ssh_config_dir

ssh_known_hosts_file:
  file.managed:
    - name: /root/.ssh/known_hosts
    - source: salt://salt/files/saltmaster_known_hosts
    - user: root
    - group: root
    - mode: 600
    - require:
      - file: ssh_config_dir

git_private_key:
  file.managed:
    - name: /root/.ssh/id_rsa_github.pem
    - user: root
    - group: root
    - mode: 600
    - contents_pillar: github_ssh_private_key
    - require:
      - file: ssh_config_dir

opsutil_private_key:
  file.managed:
    - name: /root/.ssh/id_rsa
    - user: root
    - group: root
    - mode: 600
    - contents_pillar: opsutil_ssh_private_key
    - require:
      - file: ssh_config_dir

git_ssh_config:
  file.append:
    - name: /root/.ssh/config
    - require:
      - file: git_private_key
      - file: ssh_config_file
    - text:
      - Host github github.com
      - Hostname github.com
      - User git
      - IdentityFile ~/.ssh/id_rsa_github.pem

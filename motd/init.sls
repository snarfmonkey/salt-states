motd_file:
  file.managed:
    - name: /etc/motd
    - contents: |
        This VM is a prod machine! It will get the salt states in the prod branch
        of the github repo at https://github.com/snarfmonkey/salt-states

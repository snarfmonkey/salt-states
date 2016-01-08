motd_file:
  file.managed:
    - name: /etc/motd
    - contents: |
        This VM is a {{ grains['env'] }} machine! It will get the salt states in that branch
        of the github repo at https://github.com/snarfmonkey/salt-states

install-zsh:
  pkg.installed:
    - pkgs:
      - git
      - zsh
      - curl

install-oh-my-zsh:
  cmd.run:
    - name: sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" 
    - require: [pkg: install-zsh]

install-zsh:
  pkg.installed:
    - pkgs:
      - git
      - zsh
      - curl

install-oh-my-zsh-for-everybody:
  cmd.run:
    - name: for user in $(ls /home); do su - $user -c 'sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"'; done
    - require: [pkg: install-zsh]

use-candy-theme-for-omz:
  cmd.run:
    - name: for user in $(ls /home); do su - $user -c "sed  -i 's/bobbyrussel/candy/' ~/.zshrc"; done

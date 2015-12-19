#This wont really work well in many cases, but it's for illustration
install-zsh:
  pkg.installed:
    - pkgs:
      - git
      - zsh
      - curl

switch-shells:
  cmd.run:
    - name: for user in $(ls /home); do usermod $user -s /bin/zsh; done
    - require: [pkg: install-zsh]

install-oh-my-zsh-for-everybody:
  cmd.run:
    - name: for user in $(ls /home); do su - $user -c 'sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"'; done
    - require: [cmd: switch-shells]

use-candy-theme-for-omz:
  cmd.run:
    - name: for user in $(ls /home); do su - $user -c "sed  -i 's/bobbyrussel/candy/' ~/.zshrc"; done

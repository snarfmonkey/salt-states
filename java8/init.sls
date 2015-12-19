# Add the oracle jvm ppa, and install java8
# https://launchpad.net/~webupd8team/+archive/ubuntu/java
# This is used for all java installs
# requires debconf-utils
java8_debconfutils:
  pkg.installed:
    - name: debconf-utils

java8_oracle-ppa:
  pkgrepo.managed:
    - humanname: WebUpd8 Oracle Java PPA repository
    - name: deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main
    - dist: trusty
    - file: /etc/apt/sources.list.d/webupd8team-java.list
    - keyid: EEA14886
    - keyserver: keyserver.ubuntu.com

java8_oracle-license-select:
  debconf.set:
    - name: oracle-java8-installer
    - data:
        'shared/accepted-oracle-license-v1-1': {'type': 'boolean', 'value': 'true'}

java8_oracle-installer:
  pkg.installed:
    - name: oracle-java8-installer
    - require:
      - pkgrepo: java8_oracle-ppa

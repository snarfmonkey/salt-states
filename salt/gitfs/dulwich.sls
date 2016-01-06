{% from "salt/map.jinja" import salt_settings with context %}
# issue 34

{% if salt_settings.gitfs.dulwich.install_from_source %}
# we probably don't have a package or it's not a high enough version
# install latest from source/pip
dulwich-deps:
  pkg.installed:
    - pkgs:
      - build-essential
      - python-dev
      - python-pip

# not sure why pip.installed isn't working.
install-dulwich:
  cmd.run:
    - name: pip install dulwich
    - require: [pkg: dulwich-deps]

{% else %}
# install from package
# TODO haven't actually found a distro that has a good version to test

{% endif %}

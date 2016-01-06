======================================
Salt Formula with Flightstats Flavor
======================================

.. contents::
    :local:

This is the salt-formula from saltstack, with configs and some extra states
to flightstats-ify it.

``minion.sls``
-------------------

Installs a Salt Minion. If you have the lil-debbie repo in /etc/apt/sources.list.d, the
current version that we are using will be installed from there.

``master.sls``
-------------------

Installs a Generic Salt-Master setup.

``fs_master.sls``
------------------

This installs a complete, working flightstats salt master, including all configuration, required git keys,
the master PKI, and the Dulwich python git library that we use as the backend for GitFS.

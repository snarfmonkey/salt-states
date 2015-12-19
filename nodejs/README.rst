NODE.JS Install State
=============================

This is a simple state to install node.js.

From ubuntu package
------------------------
The default is to add and install node.js 5.x  

Alternately, the defaults.yaml values can be overridden in pillar by adding the appropriate pillar file to top.sls.
Note that either key_url **or** keyid **and** keyserver must be defined.

``pillar/nodejs/v12.sls``
::
  nodejs:
    version: 0.12.0
    humanname: Nodesource Nodejs v12 Repo
    repo: deb https://deb.nodesource.com/node_0.12
    listfile: nodesource.list
    keyid: 68576280
    keyserver: keys.gnupg.net

``pillar/nodejs/v4x.sls``
::
  nodejs:
    version: 4.x
    humanname: Nodesource Nodejs 4.x Repo
    repo: deb https://deb.nodesource.com/node_4.x
    listfile: nodesource.list
    keyid: '68576280'
    key_url: https://deb.nodesource.com/gpgkey/nodesource.gpg.key
    
This allows installs from alternate repos for different versions.

Try::

  sudo salt state.sls nodejs

#!/bin/bash
# Use the Salt Project bootstrap script to install Salt
curl -L https://bootstrap.saltproject.io | sudo sh -s -- -x python3 \
    -j '{"master_type": "disable", "file_roots": {"top": ["/srv/local/top"], "base": ["/srv/local/salt", "/srv/remote/salt"]}, "startup_states": "highstate", "pub_ret": false, "mine_enabled": false, "return": "rawfile_json", "top_file_merging_strategy": "merge_all", "file_client": "local"}' \
    stable latest

# Make local directories
mkdir -p /srv/local/salt
mkdir /srv/local/top

# States for synchronized main state repo and highstate schedule
cat << EOF > /srv/local/salt/entrypoint.sls
sync_states:
  git.latest:
    - name: https://github.com/zvuki-terminala/SaltStack.git
    - target: /srv/remote
    - force_checkout: True
    - force_clone: True
    - force_fetch: True
    - force_reset: True
    - submodules: True
    - order: 1

sync_all_modules:
  saltutil.sync_all:
    - refresh: True
    - order: 1
    - onchanges:
      - git: sync_states
EOF

# Top file in a fake environment to be merged with the remote top
cat << EOF > /srv/local/top/top.sls
base:
  "*":
    - entrypoint
EOF

# Restart the service to run a highstate with the local files in place
salt-call service.restart salt-minion
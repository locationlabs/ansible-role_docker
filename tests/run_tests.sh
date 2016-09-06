#!/bin/bash

BUILD_DIR=./build
VENV_DIR=$BUILD_DIR/test_venv
INVENTORY=$BUILD_DIR/inventory

function before_run() {
   if [ ! -d $VENV_DIR ] ; then
      virtualenv $VENV_DIR
      $VENV_DIR/bin/pip install -r requirements.txt
   fi

   if [ "$VIRTUAL_ENV" != "" ] ; then
      deactivate
   fi
   . $VENV_DIR/bin/activate
}

function before_test() {
   vagrant up

   vagrant ssh-config | awk '
      BEGIN { entry = "[all]" };
      /^Host / { print entry; entry = $2 };
      /^  HostName / { entry = entry " ansible_host=" $2 };
      /^  User / { entry = entry " ansible_user=" $2 };
      /^  Port / { entry = entry " ansible_port=" $2 };
      /^  IdentityFile / { entry = entry " ansible_ssh_private_key_file=" $2 };
      END { print entry }' > $INVENTORY
}

function run_ansible_playbook() {
   echo " ------------------------------ running ansible playbook $@"
   ansible-playbook -vvv -i $INVENTORY "$@"
   local result=$?
   echo " ------------------------------ return code: $result"
   return $result
}

function after_test() {
   vagrant destroy -f
}

ALL_TESTS="old_install new_install upgrade"

function run_old_install_test() {
   run_ansible_playbook old_install.yml
}

function run_new_install_test() {
   run_ansible_playbook new_install.yml
}

function run_upgrade_test() {
   run_ansible_playbook upgrade_part1.yml && \
      run_ansible_playbook upgrade_part2.yml
}

before_run
for TEST in ${TESTS:-$ALL_TESTS} ; do
   echo "Running test \"$TEST\""
   before_test
   run_${TEST}_test
   after_test
done


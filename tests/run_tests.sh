#!/bin/bash

BUILD_DIR=./build
VENV_DIR=$BUILD_DIR/test_venv
INVENTORY=$BUILD_DIR/inventory

function before_run() {
   if [ "$VIRTUAL_ENV" != "" ] ; then
      echo "You currently have a virtual env active. Please deactivate it before proceeding."
      exit 1
   fi
   if [ ! -d $VENV_DIR ] ; then
      virtualenv $VENV_DIR
      $VENV_DIR/bin/pip install -r requirements.txt
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

ALL_TESTS="old_install new_install restart_on_config_change"

function run_old_install_test() {
   run_ansible_playbook old_install.yml
}

function run_new_install_test() {
   run_ansible_playbook new_install.yml
}

function run_restart_on_config_change_test() {
   run_ansible_playbook new_install.yml && \
      run_ansible_playbook restart_on_config_change_test.yml
}


before_run
RESULTS=""
for TEST in ${TESTS:-$ALL_TESTS} ; do
   echo "Running test \"$TEST\""
   before_test
   run_${TEST}_test
   RESULTS="${RESULTS}Test $TEST : result $?\n"
   after_test
done
echo -e "$RESULTS"

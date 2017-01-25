#!/bin/bash

BUILD_DIR=./build
VENV_DIR=$BUILD_DIR/test_venv
INVENTORY=$BUILD_DIR/inventory
VAGRANT_INVENTORY=.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory

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
   # TODO:
   # It might be faster to rollback to a snapshot taken before a run here
   # since updating apt cache can take a bit of time.
   # Unfortunately, it would require users installing more plugins or
   # updating vagrant. Snapshots are built into vagrant 1.8.0:
   # https://www.hashicorp.com/blog/vagrant-1-8.html
   vagrant up

   # create a link to generated inventory file for convenience
   # don't overwrite in case user wants to use a different inventory
   if [ ! -e $INVENTORY ] ; then
      ln -s $(readlink -f $VAGRANT_INVENTORY) $INVENTORY
   fi

   # This was a part of the Vagrantfile, but moved here for faster results.
   provision_vagrant_hosts
}

function provision_vagrant_hosts() {
   echo " ------------------------------ run provisioning script"
   ansible-playbook -v -i $INVENTORY ansible_vagrant_provisioning.yml
   local result=$?
   echo " ------------------------------ return code: $result"
   return $result
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

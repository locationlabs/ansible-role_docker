# Tests

Here are some playbooks that support different tests, and some code to support running
them in Vagrant.

## Running tests
The tests are written as Ansible playbooks that operate on `hosts: all`. The tests don't
assume much about the machine they're operating on, but it should be a clean machine if
possible.

You could use just the playbooks, but there's also a provided Vagrantfile, ansible
inventory, and test runner shell script.

To run all tests:

  ./run_tests.sh

To run a specific test:

  TESTS=upgrade ./run_tests.sh

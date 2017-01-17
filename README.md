docker
======

Installs Docker on Ubuntu.

Well tested on 14.04. Has been known to work on 12.04.

This role started from the *angstwad* *docker_ubuntu* role and has since forked a bit, primarily
to manage which version of Docker we install. Because of interdepencies between the Docker API
version and software that we install (especially `docker-py`), we have to be careful about
Docker versions.

  - Our initial deploys used a fixed version of LXC Docker, pinned at `1.5.0`
  - Our newer deploy will still use a pinned version Docker Engine, but will be able to specify
    their own versions (e.g. `1.8.1`)

Upgrade Support
---------------

This role no longer directly supports upgrading docker from a previous version. Any additional
steps required as a part of an upgrade should be taken care of in a separate role or playbook.

Kernel Requirements
-------------------

Docker has some kernel requirements for proper usage with Ubuntu. We have a new role
ansible-role_kernel_update which will assist with the kernel requirements.

Role Variables
--------------

  - `docker_version`: this variable controls the version of Docker that is installed. Required.
    If version `1.5.0` is selected, LXC Docker will be used; otherwise the stated version of
    Docker Engine will be installed (if available).
  - `docker_daemon_flags`: Empty by default. This variable holds flags that will be passed to
    the Docker daemon on startup. (This is implemented by modifying the file `/etc/default/docker`.)
  - `docker_daemon_startup_retries`: this variable controls how many times we poll docker to
    confirm it is running after we start or restart it before giving up. Defaults to 10.

Documentation
-------------

The documentation for working with Docker on Ubuntu is available online but there has been
some refactoring of the documentation since the original writing.

  * https://docs.docker.com/engine/installation/linux/ubuntu/
  * (old) https://github.com/docker/docker.github.io/blob/master/engine/installation/linux/ubuntulinux.md
  * (new) https://github.com/docker/docker.github.io/blob/master/engine/installation/linux/ubuntu.md

The *old* documentation is what was previously available online and the *new* documentation is what is
currently available online. As of this writing the documentation is at commit '45a19ec' & '9093e0a' respectively.

  * (old) https://github.com/docker/docker.github.io/blob/45a19ec/engine/installation/linux/ubuntulinux.md
  * (new) https://github.com/docker/docker.github.io/blob/9093e0a/engine/installation/linux/ubuntu.md

Links to documentation will therefore get pinned to a particular commit to maintain access
to historical information which may get removed (or moved) in later versions. Maintainers
should check the master branch when updating the role and update links when possible.

Currently the new documentations says docker is only supported on 14.04[LTS], 16.04[LTS], & 16.10
but the old documentation has some instructions for 12.04[LTS].

12.04 may not have support due to issues with older kernels. Docker documentation mentions some
prerequisites when installing from a binary that could be informative and there is a known
issue with docker running on linux kernels less than 3.19 that could imply 12.04 isn't supported.

  * https://docs.docker.com/engine/installation/binaries/#/prerequisites
  * https://github.com/docker/docker/issues/21704#issuecomment-235365424

Additional Resources
--------------------

Users of this role might also consider reviewing our other ansible roles.
In particular:

  * https://github.com/locationlabs/ansible-role_docker-base

Testing
-------

There's a directory "tests" with some Ansible playbooks that can be used for verifying role
behavior. See tests/TESTS.md for more information.

License
-------

Apache v2.0

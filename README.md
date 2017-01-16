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


Kernel Upgrade
--------------

This role currently supports upgrading the linux kernel for a few Ubuntu LTS releases in order
to address known issues with docker. These steps are expected to be refactored into a separate
role in the future.

Role Variables
--------------

  - `docker_version` : this variable controls the version of Docker that is installed. Required.
    If version `1.5.0` is selected, LXC Docker will be used; otherwise the stated version of
    Docker Engine will be installed (if available).
  - `docker_daemon_flags` : Empty by default. This variable holds flags that will be passed to
    the Docker daemon on startup. (This is implemented by modifying the file `/etc/default/docker`.)
  - `cgroup_lite_pkg_state` : When installing on an Ubuntu 13.10 host, the role will install the
    `cgroup-lite` package to provide the required cgroups support. This variable can be set to
    `latest` - the default - or to `present`. In the former case, the package will be updated, if
    necessary, when the role is run. In the latter, the package will only be added if it is not
    present.
  - `kernel_pkg_state` : The state of any kernel package installed as a part of this role.
    This parameter works the same way as `cgroup_lite_package_state`, except controlling
    kernel packages.
  - `ssh_port`: Which port to poll to confirm the box is accessible via ssh.
  - `docker_role_apt_cache_valid_time`: The apt cache valid time for this role. Used when running
    apt commands.


Testing
-------

There's a directory "tests" with some Ansible playbooks that can be used for verifying role
behavior. See tests/TESTS.md for more information.

License
-------

Apache v2.0

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

Some Docker Engine upgrade paths have known issues. There's code in this role that attempts to
resolve those issues, with minimum disruption, if those upgrade paths are encountered. The
intention is to not require containers to be recreated.

This code isn't intended to catch everything; an attempt has been made to make it reasonable and
non-harmful, but it hasn't been tested for all possible upgrade paths, nor with features like
non-local storage drivers. With that in mind, this behavior is optional and is disabled by default.

The issues we attempt to resolve are documented in the "repair_docker_data_volumes" module.


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
  - `kernel_pkg_state` : For 13.04+, this role will install a `linux-image-extra-<version>`
    package. This parameter works the same way as `cgroup_lite_package_state`, except controlling
    this package.


Testing
-------

There's a directory "tests" with some Ansible playbooks that can be used for verifying role
behavior. See tests/TESTS.md for more information.

License
-------

Apache v2.0

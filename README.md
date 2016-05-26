docker
======

Installs Docker on Ubuntu.

Well tested on 14.04. Has been known to work on 12.04 and 16.04.

This role started from the *angstwad* *docker_ubuntu* role and has since forked a bit, primarily
to manage which version of Docker we install. Because of interdepencies between the Docker API
version and software that we install (especially `docker-py`), we have to be careful about
Docker versions.

 -  Our initial deploys used a fixed version of LXC Docker, pinned at `1.5.0`
 -  Our newer deploy will still use a pinned version Docker Engine, but will be able to specify
    their own versions (e.g. `1.8.1`)


Role Variables
--------------

The `docker_version` variable controls what version of Docker is installed.

 -  The default `docker_version` is `1.5.0` (for historical reasons). If select, LXC Docker will be used.
 -  Otherwise, the stated version of Docker Engine will be used. (If not available, install will fail.)

The `docker_configuration_content` variable may be specified; if so, then the YML content will be converted
to JSON and stored in /etc/docker/daemon.json. If the file changes, the daemon will be restarted. This allows
users to specify Docker daemon coonfiguration. For more info, see:
https://docs.docker.com/engine/reference/commandline/daemon/#daemon-configuration-file


Testing
-------

There are known incompatibilities between some Docker versions and some versions of `docker-py`,
especially between LXC Docker `1.5.0` and `docker-py>1.1.0`. Using this combination will
result in Python errors along the lines of:

    client and server don't have same version (client : 1.19, server: 1.17)

Fortunately, newer versions of Docker Engine with both newer and older versions of `docker-py`
appear to be compatible. A `testing.yml` playbook is provided for reference.


License
-------

Apache v2.0

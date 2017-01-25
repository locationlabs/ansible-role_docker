Version 3.0:
 - Removed any kernel upgrading and related variables. Moved to a new role.
   See: https://github.com/locationlabs/ansible-role_docker-base
 - Refactored testing.
 - Ensure a few required packages are getting installed.  
 
Version 2.2.1:
 - wait for Docker to actually be running before re-reading ansible docker facts.

Version 2.2:
 - Removed the upgrade fixes added in Version 2.1.
 - No longer pass the "--force-confnew" flag to apt when installing the Docker package.
   This flag, added in 2.1.2, turned out to have some undesirable side effects.
 - Role now manages the "/etc/default/docker" file. The config variable "docker_daemon_flags"
   controls what is passed to DOCKER_OPTS in that file.

Version 2.1.2:
 - Pass the "--force-confnew" flag to dpkg when installing the Docker package, to make
   sure configuration files are replaced even if they have been edited.

Version 2.1.1:
 - Stop the "docker" service before attempting a package upgrade, to prevent an intermittent
   upgrade failure.

Version 2.1:
 - Removed default docker version; "docker_version" is now a required variable.
 - Attempt to handle data volume loss when we update from pre-1.10 to post-1.10.
   See: https://github.com/docker/docker/issues/20079
 - Attempt to handle missing volume symlinks when we upgrade pre-1.9 data volumes
   to a post-1.9.x version.
 - Add "docker_attempt_upgrade_fixes" configuration variable. This defaults to False;
   the upgrade fixes mentioned above won't be attempted unless it is set to True.
 - Added automated tests in the "tests" directory - if you have Vagrant installed, they
   can be run by "cd tests ; ./run_tests.sh".

Version 2.0:
  - Port to github

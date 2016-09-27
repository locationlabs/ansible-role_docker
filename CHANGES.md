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

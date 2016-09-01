Version 2.1:
 - Change default Docker version to 1.11.2, was 1.5.0
 - Attempt to handle data volume loss when we update from pre-1.10 to post-1.10.
   See: https://github.com/docker/docker/issues/20079
 - Attempt to handle missing volume symlinks when we upgrade pre-1.9 data volumes
   to a post-1.9.x version.
 - Add "docker_attempt_upgrade_fixes" configuration variable. This defaults to False;
   the upgrade fixes mentioned above won't be attempted unless it is set to True.

Version 2.0:
  - Port to github

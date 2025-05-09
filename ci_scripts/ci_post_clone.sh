
#!/bin/sh

REPO_PATH="/Volumes/workspace/repository"

if [ "$CI_WORKFLOW" = "Code Coverage Check" ]
then
  # fetch a reference to the develop branch on GitHub
  # this will allow SonarQube analysis to work
  git -C $REPO_PATH checkout -b temp

  git -C $REPO_PATH config remote.origin.fetch \
    "+refs/heads/$CI_PULL_REQUEST_SOURCE_BRANCH:refs/remotes/origin/$CI_PULL_REQUEST_SOURCE_BRANCH"
  git -C $REPO_PATH config remote.origin.fetch \
    "+refs/heads/$CI_PULL_REQUEST_TARGET_BRANCH:refs/remotes/origin/$CI_PULL_REQUEST_TARGET_BRANCH"
  git -C $REPO_PATH fetch
fi

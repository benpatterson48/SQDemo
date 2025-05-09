#!/bin/sh

REPO_PATH="/Volumes/workspace/repository"

if [ "$CI_WORKFLOW" = "Code Coverage Check" ]
then
  # fetch a reference to the develop branch on GitHub
  # this will allow SonarQube analysis to work
  git -C $REPO_PATH checkout -b temp

  # Clean the PR target branch name to ensure it doesn't contain path-like components
  CI_PR_TARGET_CLEANED=$(basename "$CI_PULL_REQUEST_TARGET_BRANCH")
  CI_PR_SOURCE_CLEANED=$(basename "$CI_PULL_REQUEST_SOURCE_BRANCH")

  git -C $REPO_PATH config remote.origin.fetch \
    "+refs/heads/$CI_PR_SOURCE_CLEANED:refs/remotes/origin/$CI_PR_SOURCE_CLEANED"
  git -C $REPO_PATH config remote.origin.fetch \
    "+refs/heads/$CI_PR_TARGET_CLEANED:refs/remotes/origin/$CI_PR_TARGET_CLEANED"
  git -C $REPO_PATH fetch
fi

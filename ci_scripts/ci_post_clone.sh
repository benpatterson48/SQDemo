#!/bin/sh

REPO_PATH="/Volumes/workspace/repository"

if [ "$CI_WORKFLOW" = "Code Coverage Check" ]
then
  # fetch a reference to the develop branch on GitHub
  # this will allow SonarQube analysis to work
  git -C $REPO_PATH checkout -b temp

# Debug to verify what we're actually receiving
echo "Raw target branch: $CI_PULL_REQUEST_TARGET_BRANCH"
echo "Raw source branch: $CI_PULL_REQUEST_SOURCE_BRANCH"

# Clean the PR branch names (strip everything before final component)
CI_PR_TARGET_CLEANED=$(echo "$CI_PULL_REQUEST_TARGET_BRANCH" | sed -E 's#.*/##')
CI_PR_SOURCE_CLEANED=$(echo "$CI_PULL_REQUEST_SOURCE_BRANCH" | sed -E 's#.*/##')

echo "Cleaned target: $CI_PR_TARGET_CLEANED"
echo "Cleaned source: $CI_PR_SOURCE_CLEANED"

  git -C $REPO_PATH config remote.origin.fetch \
    "+refs/heads/$CI_PR_SOURCE_CLEANED:refs/remotes/origin/$CI_PR_SOURCE_CLEANED"
  git -C $REPO_PATH config remote.origin.fetch \
    "+refs/heads/$CI_PR_TARGET_CLEANED:refs/remotes/origin/$CI_PR_TARGET_CLEANED"
  git -C $REPO_PATH fetch
fi

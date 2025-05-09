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

  git -C "$REPO_PATH" remote add fork "https://x-access-token:${SQ_DEMO_TOKEN}@github.com/${CI_PULL_REQUEST_REPO_OWNER}/${CI_PULL_REQUEST_REPO_NAME}.git"
  git -C "$REPO_PATH" fetch origin "$CI_PULL_REQUEST_TARGET_BRANCH"
  git -C "$REPO_PATH" fetch fork "$CI_PULL_REQUEST_SOURCE_BRANCH"

echo "Branches available after fetch:"
git -C "$REPO_PATH" branch -a
fi

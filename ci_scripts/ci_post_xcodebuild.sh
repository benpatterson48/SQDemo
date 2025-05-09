#!/bin/sh

# This script runs after Xcode Cloud's build step, and if the action is `build-for-testing`,
# it re-runs tests with code coverage enabled, converts results to SonarQube format,
# and uploads them to SonarCloud for analysis.

# Only proceed if the workflow is Code Coverage Check
if [ "$CI_WORKFLOW" = "Code Coverage Check" ]
then
    # Remove any previous result bundle if it exists
    rm -rf $CI_RESULT_BUNDLE_PATH
        
    # Re-run tests using the same build, enabling code coverage and saving results
    xcodebuild \
      -project "/Volumes/workspace/repository/SQDemo.xcodeproj" \
      -scheme "SQDemo" \
      -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
      -enableCodeCoverage YES \
      -resultBundlePath $CI_RESULT_BUNDLE_PATH \
      test-without-building
      
    # Intall SonarScanner for coverage reporting
    brew install sonar-scanner
    
    # Convert `.xcresult` to SonarQube generic XML format
    bash ci_scripts/xccov-to-sonarqube-generic.sh /Volumes/workspace/*.xcresult > AAAAA.xml
    cat AAAAA.xml | grep file
    
    SONAR_ARGS=(
      -Dsonar.projectBaseDir=/Volumes/workspace/repository \
      -Dsonar.organization=benpatterson48 \
      -Dsonar.projectKey=benpatterson48_SQDemo \
      -Dsonar.sources=. \
      -Dsonar.host.url=https://sonarcloud.io \
      -Dsonar.coverageReportPaths=AAAAA.xml \
      -Dsonar.scm.provider=git
    )
    
    # Add pull request metadata only if PR environment variables exist
    if [[ -n "$CI_PULL_REQUEST_NUMBER" && -n "$CI_PULL_REQUEST_SOURCE_BRANCH" && -n "$CI_PULL_REQUEST_TARGET_BRANCH" ]]; then
      echo "==> Detected PR context, appending PR metadata"
      SONAR_ARGS+=(
        -Dsonar.pullrequest.key=$CI_PULL_REQUEST_NUMBER
        -Dsonar.pullrequest.branch=$CI_PULL_REQUEST_SOURCE_BRANCH
        -Dsonar.pullrequest.base=$CI_PULL_REQUEST_TARGET_BRANCH
      )
    else
      echo "==> Not a PR-triggered workflow."
    fi

    sonar-scanner "${SONAR_ARGS[@]}"
else
    echo "==> Not running sonar-scanner or PR check process."
fi

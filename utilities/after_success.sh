#!/bin/bash

# This script is used by Travis-CI to publish artifacts (binary, sorce and javadoc jars) when releasing snapshots.
# This script is referenced in .travis.yml.

echo "Travis branch:       " ${TRAVIS_BRANCH}
echo "Travis pull request: " ${TRAVIS_PULL_REQUEST}
echo "Travis JDK version:  " ${TRAVIS_JDK_VERSION}
if [ "${TRAVIS_JDK_VERSION}" == "oraclejdk7" -a "${TRAVIS_BRANCH}" == "master" -a "${TRAVIS_PULL_REQUEST}" == "false" ]; then
    echo `git config --get remote.origin.url`
    git config --global user.email "Travis CI"
    git config --global user.name "ajay.kannan.15@dartmouth.edu"
    #git clone -b gh-pages https://${CI_DEPLOY_USERNAME}:${CI_DEPLOY_PASSWORD}@github.com/testuser-aj/temptest.git
    git clone -b gh-pages `git config --get remote.origin.url` .
    #git remote set-url origin git@github.com:${CI_DEPLOY_USERNAME}/temptest.git
    SITE_VERSION=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | grep -Ev '(^\[|Download\w+:)')
    SITE_VERSION="$(cut -d '-' -f 1 <<< "$SITE_VERSION")"
    mkdir -p site/latest/
    touch site/latest/index.html
    echo "<html><head><meta http-equiv=\"refresh\" content=\"0; URL='http://googlecloudplatform.github.io/gcloud-java/site/$SITE_VERSION />'\"</head><body></body></html>" > site/latest/index.html
    git add site/latest/index.html
    git commit -m "Updating latest website version"
    git push --force --quiet "https://${GH_TOKEN}@github.com/testuser-aj/temptest.git" origin gh-pages

    #mvn cobertura:cobertura coveralls:report
    #mvn site-deploy -DskipTests=true --settings=target/travis/settings.xml
    #mvn deploy -DskipTests=true -Dgpg.skip=true --settings target/travis/settings.xml
else
    echo "Not deploying artifacts. This is only done with non-pull-request commits to master branch with Oracle Java 7 builds."
fi

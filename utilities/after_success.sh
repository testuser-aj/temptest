#!/bin/bash

# This script is used by Travis-CI to publish artifacts (binary, sorce and javadoc jars) when releasing snapshots.
# This script is referenced in .travis.yml.

echo "Travis branch:       " ${TRAVIS_BRANCH}
echo "Travis pull request: " ${TRAVIS_PULL_REQUEST}
echo "Travis JDK version:  " ${TRAVIS_JDK_VERSION}
if [ "${TRAVIS_JDK_VERSION}" == "oraclejdk7" -a "${TRAVIS_BRANCH}" == "master" -a "${TRAVIS_PULL_REQUEST}" == "false" ]; then
    #mvn cobertura:cobertura coveralls:report
    #mvn site-deploy -DskipTests=true --settings=target/travis/settings.xml
    
    # Create/update "latest" html page to redirect to the most recently generated website
    git config --global user.name "Travis CI"
    git config --global user.email ${CI_DEPLOY_USERNAME}@github.com
    git clone https://github.com/testuser-aj/temptest.git
    cd temptest
    SITE_VERSION=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | grep -Ev '(^\[|Download\w+:)')
    SITE_VERSION=${SITE_VERSION%-*} # Strip "-SNAPSHOT" out of version as necessary
    git checkout gh-pages
    mkdir -p site/latest/
    touch site/latest/index.html
    echo "<html><head><meta http-equiv=\"refresh\" content=\"0; URL='http://googlecloudplatform.github.io/gcloud-java/site/${SITE_VERSION}/index.html'\" /></head><body></body></html>" > site/latest/index.html
    git add site/latest/index.html
    sed -i "s/SITE_VERSION/$SITE_VERSION/g" site/${SITE_VERSION}/index.html
    git add site/${SITE_VERSION}/index.html
    git commit -m "Updating to reflect latest website version"
    git push --force "https://${CI_DEPLOY_USERNAME}:${CI_DEPLOY_PASSWORD}@github.com/testuser-aj/temptest.git" #origin gh-pages

    #mvn deploy -DskipTests=true -Dgpg.skip=true --settings target/travis/settings.xml
else
    echo "Not deploying artifacts. This is only done with non-pull-request commits to master branch with Oracle Java 7 builds."
fi

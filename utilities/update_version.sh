#!/bin/bash

# This script updates the READMEs with the latest non-SNAPSHOT version number and increments the SNAPSHOT 
# version number in the pom.xml files.

# Precondition: the version in pom.xml does not contain "SNAPSHOT" before running this script.  
# Argument (optional):
#   $1: new version number for pom.xml files (do not include -SNAPSHOT, that is done automatically).
#   Providing no argument defaults to incrementing revision number from x.y.z-SNAPSHOT to x.y.z+1-SNAPSHOT

# Example: Suppose that before running this script, the pom reads 7.8.9-SNAPSHOT.  This script will replace 
# all occurrences of #.#.# with 7.8.9 in the README files and the first occurrence of 7.8.9-SNAPSHOT with 
# 7.8.10-SNAPSHOT in the pom.xml files.

# Get the previous maven project version.
RELEASED_VERSION=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | grep -Ev '(^\[|\w+:)')
DEFAULT_UPDATE="${RELEASED_VERSION%.*}.$((${RELEASED_VERSION##*.}+1))"
NEW_SNAPSHOT_VERSION=${1:-$DEFAULT_UPDATE}-SNAPSHOT

echo "Changing version to $RELEASED_VERSION in README files"
echo "Changing version to $NEW_SNAPSHOT_VERSION in pom.xml files"

sed -ri "s/<version>[0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*</version>/<version>${RELEASED_VERSION}</version>/g" README.md
sed -ri "s/<version>[0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*</version>/<version>${RELEASED_VERSION}</version>/g" gcloud-java/README.md
sed -ri "s/<version>[0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*</version>/<version>${RELEASED_VERSION}</version>/g" gcloud-java-core/README.md
sed -ri "s/<version>[0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*</version>/<version>${RELEASED_VERSION}</version>/g" gcloud-java-datastore/README.md
sed -ri "s/<version>[0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*</version>/<version>${RELEASED_VERSION}</version>/g" gcloud-java-examples/README.md
sed -ri "s/<version>[0-9][0-9]*.[0-9][0-9]*.[0-9][0-9]*</version>/<version>${RELEASED_VERSION}</version>/g" gcloud-java-storage/README.md

sed -i "0,/$RELEASED_VERSION/s/$RELEASED_VERSION/$NEW_SNAPSHOT_VERSION/g" pom.xml
sed -i "0,/$RELEASED_VERSION/s/$RELEASED_VERSION/$NEW_SNAPSHOT_VERSION/g" gcloud-java/pom.xml
sed -i "0,/$RELEASED_VERSION/s/$RELEASED_VERSION/$NEW_SNAPSHOT_VERSION/g" gcloud-java-core/pom.xml
sed -i "0,/$RELEASED_VERSION/s/$RELEASED_VERSION/$NEW_SNAPSHOT_VERSION/g" gcloud-java-datastore/pom.xml
sed -i "0,/$RELEASED_VERSION/s/$RELEASED_VERSION/$NEW_SNAPSHOT_VERSION/g" gcloud-java-examples/pom.xml
sed -i "0,/$RELEASED_VERSION/s/$RELEASED_VERSION/$NEW_SNAPSHOT_VERSION/g" gcloud-java-storage/pom.xml

git add README.md
git add gcloud-java/README.md
git add gcloud-java-core/README.md
git add gcloud-java-datastore/README.md
git add gcloud-java-examples/README.md
git add gcloud-java-storage/README.md
git add pom.mxl
git add gcloud-java/pom.xml
git add gcloud-java-core/pom.xml
git add gcloud-java-datastore/pom.xml
git add gcloud-java-examples/pom.xml
git add gcloud-java-storage/pom.xml
git config --global user.name "travis-ci"
git config --global user.email "travis@travis-ci.org"
git commit -m "Updating version in README and pom.xml files."
git config --global push.default simple
git push --quiet "https://${CI_DEPLOY_USERNAME}:${CI_DEPLOY_PASSWORD}@github.com/testuser-aj/temptest.git" > /dev/null 2>

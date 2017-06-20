#!/usr/bin/env bash

REPO=`git config remote.origin.url`
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=`git rev-parse --verify HEAD`

git clone $REPO out
cd out
git checkout repo || git checkout --orphan repo # orphan makes sure that it's a branch with no history

git config user.name "Travis CI"
git config user.email "travis@travis-ci.org"

mkdir -p ~/.m2/repository/
cd ..

cp -r ./out ~/.m2/repository/

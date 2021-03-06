#!/usr/bin/env bash

REPO=`git config remote.origin.url`
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=`git rev-parse --verify HEAD`

cd out

rm -r ./*

mkdir -p ./net/burngames/MavenGithubRepo
cp -r ~/.m2/repository/net/burngames/MavenGithubRepo/ ./net/burngames/

# why are these included??
rm .travis.yml
rm .gitignore

git add --all
git commit -m "Deploy to GitHub repo: ${SHA}"

ENCRYPTED_KEY_VAR="encrypted_${ENCRYPTION_LABEL}_key"
ENCRYPTED_IV_VAR="encrypted_${ENCRYPTION_LABEL}_iv"
ENCRYPTED_KEY=${!ENCRYPTED_KEY_VAR}
ENCRYPTED_IV=${!ENCRYPTED_IV_VAR}
openssl aes-256-cbc -K $ENCRYPTED_KEY -iv $ENCRYPTED_IV -in ../travis_rsa.enc -out ../deploy_key -d
chmod 600 ../deploy_key
eval `ssh-agent -s`
ssh-add ../deploy_key

git push $SSH_REPO repo
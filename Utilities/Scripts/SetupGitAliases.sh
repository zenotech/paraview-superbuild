#!/usr/bin/env bash

echo "Setting up useful Git aliases..." &&

# General aliases that could be global
git config alias.prepush 'log --graph --stat origin/master..' &&

# Alias to push the current topic branch to Gerrit
gerrit_disabled="ParaViewSuperbuild no longer uses Gerrit. Please use GitLab." &&
git config alias.gerrit-push '!sh -c "echo '"${gerrit_disabled}"'"' &&

# Alias to push the current topic branch to GitLab
git config alias.gitlab-push '!bash Utilities/GitSetup/git-gitlab-push' &&

true

#!/usr/bin/env bash

# Make sure we are inside the repository.
cd "${BASH_SOURCE%/*}/.."

echo "Ensuring all submodules are checked out and up to date..."
git submodule init
git submodule sync
git submodule update

# Rebase master by default
git config rebase.stat true
git config branch.master.rebase true

echo "Checking basic user information..."
Scripts/GitSetup/setup-user
echo

Scripts/GitSetup/setup-hooks
echo

echo "Setting up git aliases..."
Scripts/setup-git-aliases
echo

echo "Setting up Gerrit..."
Scripts/GitSetup/setup-gerrit ||
  echo "Failed to setup Gerrit. Run this script again to retry."
echo

setup_version=1
git config hooks.setup ${setup_version}

echo "Setup for development complete for ParaViewSuperbuild."

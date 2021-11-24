#!/bin/sh

set -e

# figure out which branch we're targeting
#   CI_COMMIT_BRANCH is set when building a branch,
#   CI_COMMIT_TAG is set when building a tag, and
#   CI_MERGE_REQUEST_TARGET_BRANCH_NAME is set when building an MR.
# We check them one after the other to pick the default branch name.
readonly url="${PARAVIEW_URL:-https://gitlab.kitware.com/paraview/paraview.git}"

# figure out which ParaView branch to checkout.
if [ -n "$PARAVIEW_BRANCH" ]; then
    pv_branch="$PARAVIEW_BRANCH"
elif [ -n "$CI_COMMIT_TAG" ]; then
    pv_branch="$CI_COMMIT_TAG"
elif [ -n "$CI_MERGE_REQUEST_TARGET_BRANCH_NAME" ]; then
    pv_branch="$CI_MERGE_REQUEST_TARGET_BRANCH_NAME"
elif [ -n "$CI_COMMIT_BRANCH" ]; then
    pv_branch="$CI_COMMIT_BRANCH"
else
    pv_branch="master"
fi
readonly pv_branch

# The CentOS 7 containers have an old git that does not support this flag
# (added in 2.9.0).
shallow_submodules="--shallow-submodules"
if echo "$CI_JOB_NAME" | grep -q "linux.*:build"; then
    shallow_submodules=""
fi
readonly shallow_submodules

# full clone of paraview with shallow-submodule. full clone needed so that `git describe` works correctly
git clone --recursive $shallow_submodules -b "$pv_branch" "$url" "$CI_PROJECT_DIR/source-paraview"

# let's print ParaView version for reference even when the artifacts disappear
cd "$CI_PROJECT_DIR/source-paraview"
git describe
#git -C "$CI_PROJECT_DIR/source-paraview" describe

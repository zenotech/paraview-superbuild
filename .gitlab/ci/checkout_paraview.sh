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

# since we do shallow clones, we need to cleanup old checkouts
rm -rf "$CI_BUILDS_DIR/source-paraview"

# full clone of paraview with shallow-submodule. full clone needed so that `git describe` works correctly
git clone --recursive --shallow-submodules -b "$pv_branch" "$url" "$CI_BUILDS_DIR/source-paraview"

# let's print ParaView version for reference even when the artifacts disappear
git -C "$CI_BUILDS_DIR/source-paraview describe"

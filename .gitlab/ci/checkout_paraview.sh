#!/bin/sh

set -e

# figure out which branch we're targeting
#   CI_COMMIT_BRANCH is set when building a branch,
#   CI_COMMIT_TAG is set when building a tag, and
#   CI_MERGE_REQUEST_TARGET_BRANCH_NAME is set when building an MR.
# We check them one after the other to pick the default branch name.
readonly sb_branch="${CI_COMMIT_BRANCH:-${CI_COMMIT_TAG:-${CI_MERGE_REQUEST_TARGET_BRANCH_NAME:-master}}}"
readonly url="${PARAVIEW_URL:-https://gitlab.kitware.com/paraview/paraview.git}"

# figure out which ParaView branch to checkout.
readonly pv_branch="${PARAVIEW_BRANCH:-$sb_branch}"

# since we do shallow clones, we need to cleanup old checkouts
rm -rf $CI_BUILDS_DIR/source-paraview

# full clone of paraview with shallow-submodule. full clone needed so that `git describe` works correctly
git clone --recursive --shallow-submodules -b $pv_branch $url $CI_BUILDS_DIR/source-paraview

# let's print ParaView version for reference even when the artifacts disappear
git -C $CI_BUILDS_DIR/source-paraview describe

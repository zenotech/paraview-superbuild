$erroractionpreference = "stop"

if ($env:PARAVIEW_URL) {
    $url = $env:PARAVIEW_URL
} else {
    $url = "https://gitlab.kitware.com/paraview/paraview.git"
}

# figure out which ParaView branch to checkout.
if ($env:PARAVIEW_BRANCH) {
    $pv_branch = $env:PARAVIEW_BRANCH
} elseif ($env:CI_COMMIT_TAG) {
    $pv_branch = $env:CI_COMMIT_TAG
} elseif ($env:CI_MERGE_REQUEST_TARGET_BRANCH_NAME) {
    $pv_branch = $env:CI_MERGE_REQUEST_TARGET_BRANCH_NAME
} elseif ($env:CI_COMMIT_BRANCH) {
    $pv_branch = $env:CI_COMMIT_BRANCH
} else {
    $pv_branch = "master"
}

# since we do shallow clones, we need to cleanup old checkouts
if (Test-Path "$env:CI_BUILDS_DIR\source-paraview") {
    Remove-Item -Recurse "$env:CI_BUILDS_DIR\source-paraview"
}

# full clone of paraview with shallow-submodule. full clone needed so that `git describe` works correctly
git clone --recursive --shallow-submodules -b "$pv_branch" "$url" "$env:CI_BUILDS_DIR\source-paraview"

# let's print ParaView version for reference even when the artifacts disappear
git -C "$CI_BUILDS_DIR\source-paraview" describe

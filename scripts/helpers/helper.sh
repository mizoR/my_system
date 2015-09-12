#!/bin/bash

function git_clone_or_update() {
  local repo=$1
  local home=$2

  if [ -d "$home" ]; then
    ( cd $home && git pull origin `git name-rev --name-only HEAD` )
  else
    git clone --depth=1 $repo $home
  fi
}

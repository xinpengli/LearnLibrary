#!/bin/bash
git ls-remote -h  -t git@gitlab.geekplus.cc:system/publish.git  | awk -F'/' 'BEGIN {print "branch="} {print $NF}' | tr '\n' ',' >/opt/jenkins_config/config_branch.conf

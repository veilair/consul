#!/usr/bin/env bash
set -o pipefail

### This script checks if any metric behavior has been modified.
### The checks rely on the git diff against origin/main
### It is still up to the reviewer to make sure that any tests added are needed and meaningful.

# search for any "new" or modified metric emissions
metrics_modified=$(git --no-pager diff HEAD origin/main | grep -i "SetGauge\|EmitKey\|IncrCounter\|AddSample\|MeasureSince\|UpdateFilter")
# search for PR body or title metric references
metrics_in_pr_body=$(echo "$PR_BODY" | grep -i "metric")
metrics_in_pr_title=$(echo "$PR_TITLE" | grep -i "metric")

# if there have been code changes to any metric or mention of metrics in the pull request body
if [ "$metrics_modified" ] || [ "$metrics_in_pr_body" ] || [ "$metrics_in_pr_title" ]; then
  # need to check if there are modifications to metrics_test
  metrics_test_file="agent/metrics_test.go"
  modified_metrics_test_file=$(git --no-pager diff --name-only HEAD "$(git merge-base HEAD "origin/main")" | grep -i "$metrics_test_file")
  if [ "$modified_metrics_test_file" ]; then
    # 1 happy path: metrics_test has been modified bc we modified metrics behavior
    echo "PR seems to modify metrics behavior. It seems it may have added tests to agent/metrics_test.go as well."
    exit 0
  else
    echo "PR seems to modify metrics behavior. It seems no tests or test behavior has been modified in agent/metrics_test.go."
    echo "Please update the PR with any relevant updated testing or add a pr/no-metrics-test label to skip this check."
    exit 1
  fi

else
  # no metrics modified in code, nothing to check
  echo "No metric behavior seems to be modified."
  exit 0
fi

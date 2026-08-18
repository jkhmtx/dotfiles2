#!/usr/bin/env bash

git fetch && git rebase --interactive "${@:-origin/main}"

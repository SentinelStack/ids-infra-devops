#!/usr/bin/env bash
set -euo pipefail

sudo systemctl restart backend-api
sudo systemctl --no-pager status backend-api


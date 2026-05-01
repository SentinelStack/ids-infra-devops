#!/usr/bin/env bash
set -euo pipefail

sudo systemctl restart ids-platform-backend
sudo systemctl --no-pager status ids-platform-backend


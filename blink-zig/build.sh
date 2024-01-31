#!/usr/bin/env bash
# Note: zig 0.11.0 has issues with volatile, use zig > 0.11.0
set -eu

zig build

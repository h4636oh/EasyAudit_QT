#!/usr/bin/env bash

# Execute ufw status verbose and filter for lines containing "Default"
ufw status verbose | grep "Default:"


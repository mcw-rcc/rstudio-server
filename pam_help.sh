#!/usr/bin/env bash

IFS='' read -r password

# Authenticate user
if [[ "${USER}" == "${1}" && "${RSTUDIO_PASSWORD}" == "${password}" ]]; then
  echo "Successful authentication"
  exit 0
else
  echo "Invalid authentication"
  exit 1
fi

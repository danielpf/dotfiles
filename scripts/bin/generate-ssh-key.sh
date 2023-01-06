#!/bin/sh

if [ -z "$1" ] ; then
  echo "missing name"
  exit 1
fi

ssh-keygen -t ed25519 -b 512 -C "$1" -f "$1" -N ""


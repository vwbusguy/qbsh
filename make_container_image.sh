#!/bin/bash

qb64 -x $PWD/qbsh.bas -o $PWD/qbsh;
podman build --pull=true -t qbsh:latest . ;

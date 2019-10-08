#!/usr/bin/env bash

KEY_NAME=myid_ecdsa
rm ${KEY_NAME}*
ssh-keygen -t ecdsa -f ${KEY_NAME} -P "" -N "" -C ""

KEY_NAME=myid_rsa
rm ${KEY_NAME}*
ssh-keygen -t rsa -f ${KEY_NAME} -P "" -N "" -C ""

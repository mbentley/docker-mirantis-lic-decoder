#!/bin/sh

# make sure a parameter (license) was passed
if [ -z "${1}" ]
then
  echo "ERROR: no license data sent as first parameter"
  exit 1
fi

# break apart the JWT into the main parts; send errors to null (gets past padding errors)
JWT_HEADER="$(echo "${1}" | awk -F '.' '{print $1}' | sed 's/-/+/g; s/_/\//g' | base64 -d 2>/dev/null)"
JWT_PAYLOAD="$(echo "${1}" | awk -F '.' '{print $2}' | sed 's/-/+/g; s/_/\//g' | base64 -d 2>/dev/null)"
JWT_SIGNATURE="$(echo "${1}" | awk -F '.' '{print $3}' | tr -d '%' | sed 's/-/+/g; s/_/\//g' | base64 -d 2>/dev/null)"

# validate that we were able to decode all 3 portions
if [ -z "${JWT_HEADER}" ] || [ -z "${JWT_PAYLOAD}" ] || [ -z "${JWT_SIGNATURE}" ]
then
  echo "ERROR: invalid license or unable to parse"
  exit 1
fi

# output the raw details
echo "Raw License Details:"
echo "Header:  $(echo "${JWT_HEADER}" | jq -c -C .)"
echo "Payload: $(echo "${JWT_PAYLOAD}" | jq -c -C .)"
echo

# output the pretty jq formatted details
echo "Pretty details:"
echo "Header:"
echo "${JWT_HEADER}" | jq .
echo
echo "Payload:"
echo "${JWT_PAYLOAD}" | jq .
echo

# output the valid dates
echo "Not Valid Before: $(date -d @"$(echo "${JWT_PAYLOAD}" | jq .iat)")"
echo "Not Valid After:  $(date -d @"$(echo "${JWT_PAYLOAD}" | jq .exp)")"

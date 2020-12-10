#!/bin/sh

invalid_license() {
  echo "ERROR: invalid license"
  exit 1
}

if [ -z "${1}" ]
then
  echo "ERROR: no license data sent as first parameter"
  exit 1
fi

JWT_HEADER="$(echo "${1}" | awk -F '.' '{print $1}' | sed 's/-/+/g; s/_/\//g' | base64 -d 2>/dev/null)"
JWT_PAYLOAD="$(echo "${1}" | awk -F '.' '{print $2}' | sed 's/-/+/g; s/_/\//g' | base64 -d 2>/dev/null)"
JWT_SIGNATURE="$(echo "${1}" | awk -F '.' '{print $3}' | tr -d '%' | sed 's/-/+/g; s/_/\//g' | base64 -d 2>/dev/null)"

if [ -z "${JWT_HEADER}" ] || [ -z "${JWT_PAYLOAD}" ] || [ -z "${JWT_SIGNATURE}" ]
then
  echo "ERROR: invalid license or unable to parse"
  exit 1
fi

echo "Raw License Details:"
echo "${JWT_HEADER}"
echo "${JWT_PAYLOAD}"
echo

echo "Pretty details:"
echo "${JWT_HEADER}" | jq .
echo "${JWT_PAYLOAD}" | jq .
echo

echo "Not Valid Before: $(date -d @"$(echo "${JWT_PAYLOAD}" | jq .iat)")"
echo "Not Valid After:  $(date -d @"$(echo "${JWT_PAYLOAD}" | jq .exp)")"

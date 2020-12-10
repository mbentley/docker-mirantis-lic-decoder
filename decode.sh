#!/bin/sh

if [ -z "${1}" ]
then
  echo "ERROR: no license data sent as first parameter"
  exit 1
fi

RAW_1="$(echo "${1}" | awk -F '.' '{print $1}' | base64 -d 2>/dev/null)"
RAW_2="$(echo "${1}" | awk -F '.' '{print $2}' | base64 -d 2>/dev/null)"
RAW_3="$(echo "${1}" | awk -F '.' '{print $3}' | tr -d '%' | base64 -d 2>/dev/null)"

LICENSE_DETAILS="$(echo "${RAW_2}" | sed 's/$/}}/' | jq . 2>/dev/null)"
echo "Raw License Details:"
echo "${RAW_1}"
echo "${RAW_2}"
echo "${RAW_3}"
echo

echo "Pretty details:"
echo "${LICENSE_DETAILS}" | jq . 2>/dev/null
echo

echo "Not Valid Before: $(date -d @"$(echo "${LICENSE_DETAILS}" | jq .iat)")"
echo "Not Valid After:  $(date -d @"$(echo "${LICENSE_DETAILS}" | jq .exp)")"

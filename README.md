# mbentley/mirantis-lic-decoder

docker image to decode Mirantis license files (JWT based)
based off of alpine:latest

To pull this image:
`docker pull mbentley/mirantis-lic-decoder`

Example usage:

```
docker run -t --rm mbentley/mirantis-lic-decoder $(cat license.lic)
```

This will output the decoded details of the licese such as quantity, valid dates, and license type.

FROM alpine:latest
MAINTAINER Matt Bentley <mbentley@mbentley.net>

RUN apk add --no-cache coreutils jq

COPY jwt_license_decode.sh /

ENTRYPOINT ["/jwt_license_decode.sh"]

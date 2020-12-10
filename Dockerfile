FROM alpine:latest
MAINTAINER Matt Bentley <mbentley@mbentley.net>

RUN apk add --no-cache coreutils jq

COPY decode.sh /

ENTRYPOINT ["/decode.sh"]

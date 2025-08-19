FROM docker.io/bellsoft/liberica-openjdk-alpine:17
WORKDIR /work

ARG USER=minecraft
ARG GROUP=minecraft
ARG PUID=845
ARG PGID=845

ENV PUID="$PUID" \
  PGID="$PGID"

RUN addgroup --system --gid "$PGID" "$GROUP" \
  && adduser --system --uid "$PUID" --ingroup "$GROUP" --no-create-home --disabled-password --gecos "" --shell /bin/sh "$USER"

RUN chmod ugo=rwx /work \
  && chown -R "$USER":"$GROUP" /work

ENTRYPOINT ["sh", "run.sh"]

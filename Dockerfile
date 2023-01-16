# syntax = docker/dockerfile:1.4.0
FROM amd64/buildpack-deps:curl

WORKDIR /app

RUN apt-get update && apt-get install -y \
  socat \
  && rm -rf /var/lib/apt/lists/*

ENV DOWNLOAD_URL https://cage-build-assets.evervault.com/cli/0.1.10/x86_64-unknown-linux-musl/ev-cage.tar.gz

RUN wget -q "$DOWNLOAD_URL" -O - | tar -xz && chmod 0755 ./bin/ev-cage
ENV PATH=$PATH:/app/bin

# ev-cage dev binds to 127.0.0.1, but Docker needs it to bind to 0.0.0.0.
# We use socat to forward TCP traffic from 0.0.0.:9992 -> 127.0.0.1:9999
RUN <<EOF cat >> bin/start.sh
socat TCP-LISTEN:9992,fork,bind=0.0.0.0 TCP:localhost:9999 &
ev-cage dev -p 9999
EOF

RUN chmod +x bin/start.sh

CMD ["bash", "-c", "start.sh"]

EXPOSE 9992

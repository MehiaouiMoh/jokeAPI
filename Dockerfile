FROM swift:6.0-jammy as build
WORKDIR /build
COPY . .
RUN swift build --build-path /build/.build --static-swift-stdlib -c release

# Étape runtime : Ubuntu Jammy au lieu de Focal
FROM ubuntu:22.04
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -q && apt-get upgrade -y -q && \
    apt-get install -y --no-install-recommends git ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /build/.build/release/vapor /usr/bin

RUN swift build --build-path /app/.build --static-swift-stdlib -c release && \
    ls -l /app/.build/release

RUN git config --global user.name "Vapor"
RUN git config --global user.email "new@vapor.codes"

CMD ["/app/.build/release/vapor", "serve", "--hostname", "0.0.0.0", "--port", "8080"]

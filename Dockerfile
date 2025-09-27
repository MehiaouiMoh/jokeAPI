# Étape 1 : build de l'exécutable avec Swift 6.0 sur Ubuntu Jammy
FROM --platform=linux/arm64 swift:6.0-jammy AS build
WORKDIR /build

# Copier tous les fichiers du projet
COPY . .

# Build en release et statique
RUN swift build --build-path /build/.build --static-swift-stdlib -c release

# Étape 2 : image runtime basée sur Ubuntu Jammy (compatibilité GLIBC)
FROM --platform=linux/arm64 ubuntu:22.04

# Installer les dépendances nécessaires
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -q && apt-get upgrade -y -q && \
    apt-get install -y --no-install-recommends git ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copier l’exécutable buildé depuis l’étape précédente
COPY --from=build /build/.build/release/vapor /usr/bin/vapor

# Configurer Git (optionnel)
RUN git config --global user.name "Vapor" && \
    git config --global user.email "new@vapor.codes"

# Lancer l’API
ENTRYPOINT ["vapor"]

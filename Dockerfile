# Étape 1 : build avec Swift officiel (ARM64)
FROM --platform=linux/arm64 swift:6.0-jammy AS build
WORKDIR /app

# Copier tous les fichiers du projet
COPY . .

# Build en release avec stdlib statique
RUN swift build --build-path /app/.build --static-swift-stdlib -c release && \
    ls -l /app/.build/release   # Vérifie le binaire généré
    echo "Contenu de /app/.build/release :" && ls -l /app/.build/release

# Étape 2 : runtime léger basé sur Ubuntu Jammy
FROM ubuntu:22.04
WORKDIR /app

# Installer les dépendances nécessaires pour l'exécutable
RUN apt-get update -q && \
    apt-get upgrade -y -q && \
    apt-get install -y --no-install-recommends git ca-certificates libatomic1 && \
    rm -rf /var/lib/apt/lists/*

# Copier le binaire compilé depuis l'étape build
COPY --from=build /app/.build/release/VaporToolbox /usr/bin/VaporToolbox

# Lancer le serveur Vapor automatiquement
CMD ["/usr/bin/VaporToolbox", "serve", "--hostname", "0.0.0.0", "--port", "8080"]

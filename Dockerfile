# Étape 1 : build avec Swift officiel
FROM swift:6.0-jammy AS build
WORKDIR /app

# Copier les fichiers du projet
COPY . .

# Compiler le projet en release
RUN swift build --build-path /app/.build --static-swift-stdlib -c release && \
    echo "Contenu du dossier release :" && ls -l /app/.build/release

# Étape 2 : image légère pour exécuter l’app
FROM ubuntu:22.04
WORKDIR /app

# Installer les dépendances minimales
RUN apt-get update -q && \
    apt-get upgrade -y -q && \
    apt-get install -y --no-install-recommends git ca-certificates libatomic1 && \
    rm -rf /var/lib/apt/lists/*

# Copier le binaire compilé
COPY --from=build /app/.build/release/vapor /usr/bin/vapor

# Démarrer le serveur Vapor automatiquement
CMD ["/usr/bin/vapor", "serve", "--hostname", "0.0.0.0", "--port", "8080"]


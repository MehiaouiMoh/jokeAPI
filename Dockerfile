# Utiliser directement l'image Swift officielle pour ARM64 (build + runtime)
FROM --platform=linux/arm64 swift:6.0-jammy

WORKDIR /app

# Copier les fichiers du projet
COPY . .

# Build en release avec la stdlib statique
RUN swift build --build-path /app/.build --static-swift-stdlib -c release

# Lancer l’exécutable Vapor
CMD ["/app/.build/release/vapor", "serve", "--env", "production", "--hostname", "0.0.0.0"]

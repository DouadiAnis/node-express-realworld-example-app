#!/bin/bash
set -e # Arrête le script si une commande échoue

echo "🚀 Démarrage du déploiement sur la VM..."

# 1. Connexion au Docker Hub (pour avoir le droit de pull l'image privée)
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin

# 2. Définition de l'image (Celle construite par le pipeline)
export DOCKER_IMAGE="$DOCKER_USERNAME/student-ci-cd-project:latest"

echo "⬇️  Téléchargement de la dernière version de l'image : $DOCKER_IMAGE"
# C'est cette ligne qui force la mise à jour !
docker compose -f docker-compose.yml pull api

echo "♻️  Redémarrage des services..."
# Le '-d' lance en fond, et Docker ne recrée QUE ce qui a changé (l'API)
docker compose -f docker-compose.yml up -d

echo "🧹 Nettoyage des vieilles images inutilisées..."
docker image prune -f

echo "✅ Déploiement terminé avec succès !"
#!/bin/bash
set -e

echo "➡️  Début de la compilation..."

cd app

# On suppose que les dépendances sont déjà là (via le job précédent ou test.sh), 
# mais par sécurité on peut refaire npm ci si lancé seul.
if [ ! -d "node_modules" ]; then
    echo "📦 Installation des dépendances..."
    npm ci
fi

echo "🔨 Compilation de l'application..."
npm run build

echo "✅ Compilation terminée. Artefacts dans app/dist/"
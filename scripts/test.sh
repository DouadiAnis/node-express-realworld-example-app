#!/bin/bash
set -e

echo "➡️  Début des tests..."

cd app

# 1. Installation des dépendances
echo "📦 Installation des dépendances..."
npm ci

# 2. Attente que la DB soit prête (optionnel mais recommandé en CI)
# Pour ce projet simple, on passe directement à la suite.

# 3. Reset de la base de données pour partir sur une base propre
echo "🧹 Nettoyage de la base de données..."
# force-reset efface toutes les données !
npx prisma db push --force-reset

# 4. Lancement des tests
echo "🧪 Exécution des tests unitaires..."
npm run test

echo "✅ Tests terminés avec succès."
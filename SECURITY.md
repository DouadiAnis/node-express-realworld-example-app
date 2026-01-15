# Politique de Sécurité du Projet

Ce document décrit les mesures de sécurité mises en œuvre tout au long du cycle de vie de l'application selon une approche **DevSecOps**, depuis l'écriture du code jusqu'au déploiement en production sur **Azure**.

La stratégie de sécurité repose sur deux principes fondamentaux :

- **Defense in Depth (Défense en profondeur)**  
- **Shift Left** : intégrer la sécurité le plus tôt possible dans le cycle de développement

---

## 1. Sécurisation de la Chaîne CI/CD (GitHub Actions)

L’automatisation est utilisée pour empêcher le déploiement de code ou d’images contenant des vulnérabilités connues.

### 🔍 Analyse de Vulnérabilités (Container Scanning)

- **Outil** : Trivy (Aqua Security)
- **Implémentation** : Intégré dans le job `build-and-push`
- **Justification** :  
  Les images Docker peuvent contenir des failles de sécurité au niveau :
  - du système d’exploitation de base (Alpine, Debian)
  - des paquets système installés

- **Politique de sécurité** :  
  Le pipeline CI/CD échoue automatiquement si une vulnérabilité de niveau **CRITICAL** ou **HIGH** est détectée.  
  Cela empêche toute image compromise d’atteindre l’environnement de production.

---

### 🧹 Qualité du Code et Analyse Statique (SAST)

- **Outils** : ESLint
- **Implémentation** : Intégrés dans le job `test-and-lint`

**Justification** :

- **ESLint** :
  - Applique les bonnes pratiques de développement
  - Évite les erreurs de syntaxe et les comportements dangereux


---

### 📦 Gestion des Dépendances

- **Outil** : GitHub Dependabot
- **Implémentation** : Activé directement sur le dépôt

**Justification** :  
Une grande partie des vulnérabilités provient des dépendances tierces (ex. `express`, `qs`).  
Dependabot analyse automatiquement les fichiers `package.json` et ouvre des *Pull Requests* pour corriger les dépendances vulnérables.

---

## 2. Gestion des Secrets et Identifiants

Aucun secret n’est stocké en clair dans le code source (*hardcoded secrets interdits*).

### 🔐 GitHub Secrets

- **Usage** :
  - Clés API
  - Identifiants Docker
  - Clés SSH
  - Identifiants de base de données

**Justification** :

- Les secrets sont **chiffrés au repos** par GitHub
- Ils sont injectés dynamiquement dans les pipelines sous forme de variables d’environnement
- Ils sont automatiquement **masqués dans les logs** d’exécution (`***`)

---

### 🔑 Authentification SSH

- **Méthode** : Clé publique / clé privée (RSA)

**Justification** :

- L’authentification par mot de passe est désactivée sur la VM Azure
- Protection contre :
  - les attaques par force brute
  - les attaques par dictionnaire

---

## 3. Sécurité de l’Infrastructure (Azure & Docker)

### 🐳 Conteneurisation (Docker)

- **Images officielles** :
  - `node:18`
  - `postgres:15-alpine`

- **Isolation** :
  - L’API et la base de données fonctionnent dans des conteneurs séparés

- **Réseau interne** :
  - Communication entre l’API et PostgreSQL via un réseau Docker privé
  - Aucun accès direct externe à la base de données

---

### 🛡️ Pare-feu et Réseau (Azure NSG)

**Principe appliqué** : Moindre privilège

**Configuration** :

- Ports ouverts uniquement si nécessaires :
  - **22** : Administration SSH
  - **3000** : Accès à l’API

- Tous les autres ports entrants sont **bloqués par défaut** par le *Network Security Group* (NSG) Azure

---

## 4. Infrastructure as Code (IaC)

### 📜 Script de déploiement (`deploy.sh`)

- Le déploiement est :
  - automatisé
  - versionné
  - reproductible

**Avantages** :

- Évite les actions manuelles sur le serveur
- Réduit les erreurs de configuration
- Limite les failles de sécurité humaines


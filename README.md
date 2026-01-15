# 🌍 Node.js RealWorld Example App - DevOps CI/CD Project

Ce projet est une mise en œuvre complète d'un pipeline **DevSecOps** pour une application Node.js/Express (RealWorld App). Il intègre l'automatisation des tests, l'analyse de qualité, le scan de vulnérabilités et le déploiement continu sur une machine virtuelle Azure.

---

## 🏗️ 1. Pipeline Architecture Diagram

Voici le flux automatisé mis en place via **GitHub Actions** :
![diagramme ](/images/diagramme.png)

## Explication de la CI/CD Stages
Le pipeline est défini dans .github/workflows/ci-cd.yml et se divise en 3 jobs séquentiels :
![pipeline ](/images/pipeline.png)

🟢 Stage 1 : Continuous Integration (CI) & Quality
Ce job valide l'intégrité du code avant toute action.

Build & Install : Installation des dépendances Node.js et compilation TypeScript.

Ephemeral Database : Lancement d'un conteneur PostgreSQL temporaire pour les tests d'intégration.

Testing : Exécution des tests unitaires via Jest.

Linting : Analyse statique avec ESLint pour vérifier le style de code.


🟡 Stage 2 : Build, Security & Push
Ce job construit l'artefact de déploiement et assure sa sécurité.

Docker Build : Création de l'image de production.

Trivy Scan : Scan de vulnérabilités (CVE) dans l'image Docker.

Politique de sécurité : Le pipeline échoue automatiquement si une faille CRITICAL ou HIGH est détectée (Quality Gate).

Docker Push : Si le scan est vert, l'image est envoyée sur le Docker Hub avec deux tags : latest et le SHA du commit.

🔵 Stage 3 : Continuous Deployment (CD)
Ce job met à jour l'application sur le serveur de production.

Accès SSH : Connexion sécurisée à la VM Azure via une clé privée SSH (stockée dans les GitHub Secrets).

Mise à jour :

Copie des fichiers de configuration (docker-compose.yml) et du script de déploiement.

Exécution du script deploy.sh sur le serveur.

Téléchargement de la nouvelle image et redémarrage des conteneurs sans interruption de la base de données.

💻 3. How to Run Locally
Pour exécuter le projet sur votre machine (en mode développement), vous avez besoin de Docker et Docker Compose.

Cloner le dépôt :

```bash

git clone https://github.com/DouadiAnis/node-express-realworld-example-app
cd node-express-realworld-example-app
```
Lancer l'application avec Docker Compose : Nous utilisons un fichier compose dédié au développement qui monte le code en volume (Hot Reload).

```bash
docker compose -f docker/docker-compose.yml up --build
```

Accéder à l'application :

```bash
API : http://localhost:3000/api
```

Base de données : Accessible sur localhost:5432

🚀 4. How to Deploy
Le déploiement est entièrement automatisé (Continuous Deployment).

Prérequis (Infrastructure)
Une VM Azure (Ubuntu) avec Docker et Docker Compose installés.

Le port 3000 ouvert dans le pare-feu Azure .

Configuration des Secrets
Pour que le déploiement fonctionne, les secrets suivants doivent être configurés dans GitHub (Settings > Secrets and variables > Actions) :

Nom du Secret	Description
DOCKER_USERNAME	Votre identifiant Docker Hub.
DOCKER_PASSWORD	Votre mot de passe ou Token d'accès Docker Hub.
VM_HOST	L'adresse IP publique de la VM Azure.
VM_USERNAME	Le nom d'utilisateur SSH (ex: azureuser).
SSH_PRIVATE_KEY	La clé privée SSH .pem complète pour accéder à la VM.



Déclencher le déploiement
Il suffit de pousser une modification sur la branche master :

```bash

git add .
git commit -m "feat: new awesome feature"
git push origin master
```

GitHub Actions prendra le relais : il testera, sécurisera, construira et déploiera la nouvelle version automatiquement sur votre serveur Azure.
# Document de projection pipeline CI/CD — Projet Flipper


Le frontend (Playfield et Backglass) tourne directement sur les machines physiques de la borne. Il n'a pas vocation à être déployé dans le cloud seul le backend Node.js nécessite un déploiement cloud, car il expose l'API REST et le serveur WebSocket que les machines et les ESP32 consomment.


## Pipeline CI/CD — Ce qui est en place

### Vue d'ensemble

```
push sur main
        │
        ▼
┌─────────────────────┐
│   1. Checkout        │  récupère le code
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│   2. Docker Buildx   │  build multi-plateforme
│   amd64 + arm64      │  
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│   3. Push            │  arthurguill/pinball-backend:latest
│   Docker Hub         │  image versionnée et publique
└────────┬────────────┘
         │
         ▼
┌─────────────────────┐
│   4. Restart         │  az webapp restart
│   Azure Web App      │  Azure pull la nouvelle image et redémarre
└─────────────────────┘
```

### Détail des étapes

```yaml
name: Deploy to Azure

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    environment: production

    steps:
      - uses: actions/checkout@v4
      - uses: docker/setup-buildx-action@v3

      - name: Login to Docker Hub
        uses: docker/login-action@v3

      - name: Build and Push
        uses: docker/build-push-action@v5
        with:
          platforms: linux/amd64,linux/arm64
          tags: arthurguill/pinball-backend:latest

      - name: Restart Azure Web App
        uses: azure/CLI@v1
        with:
          inlineScript: az webapp restart ...
```

Le job est protégé par l'environnement GitHub `production` --> reviewers obligatoires avant tout déploiement en production.


## Outils choisis et justifications

### GitHub Actions — CI/CD

**Pourquoi ?**
Le code est hébergé sur GitHub. GitHub Actions s'intègre nativement sans serveur CI à maintenir. Les secrets sont gérés directement dans l'interface GitHub. Le pipeline se déclenche automatiquement sur chaque push sur main


### Docker + Dockerfile multi-stage — Containerisation

**Pourquoi ?**
Docker garantit que l'environnement d'exécution est identique entre le développement local et la production Azure. 
```dockerfile

FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

EXPOSE 3000

CMD ["npm", "run", "start"]
```


### Docker Hub — Registry d'images

**Pourquoi ?**

Docker Hub est le registry de référence, gratuit pour les images publiques. L'image `arthurguill/pinball-backend:latest` est accessible directement par Azure sans configuration d'authentification supplémentaire.

### Terraform — Infrastructure as Code

**Pourquoi ?**
Terraform permet de décrire l'infrastructure Azure dans des fichiers versionnés dans Git. Toute modification passe par une Pull Request, est reviewée et laisse une trace dans l'hstorque. Sans Terraform ces modifications se feraient manuellement dans la console Azure sans historique et sans rollback possible.

### Azure Linux Web App — Hébergement

**Pourquoi ?**
Azure Web App en mode conteneur Linux permet de faire tourner l'image Docker directement sans gérer de serveur. Le service supporte nativement les WebSockets, indispensable pour la communication temps réel entre le backend, les ESP32 et les écrans. 

**Alternatives écartées :**

**Kubernetes** est conçu pour des architectures distribuées avec de nombreux microservices et du scaling horizontal agressif. Ce projet déploie un seul service Node.js. La complexité opérationnelle (kubeconfig, namespaces, ingress controllers) n'apporte aucune valeur ici — Azure Web App gère déjà le scaling et le redémarrage automatique.

**Helm** est un gestionnaire de packages pour Kubernetes. Sans Kubernetes dans la stack, Helm n'a pas de rôle à jouer.

**Ansible** sert à configurer des serveurs bare-metal. Dans notre architecture, il n'y a pas de serveurs à configurer manuellement — Azure gère l'environnement d'exécution et Terraform gère le provisionnement.

---

## Gestion des secrets

Aucun secret n'est commité dans le repository. Les variables sensibles sont gérées à deux niveaux :

**GitHub Actions Secrets :**
- `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`
- `AZURE_CREDENTIALS` (JSON contenant `clientId`, `clientSecret`, `tenantId`, `subscriptionId`)

**Variables d'environnement Azure** injectées par Terraform :
- `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `ALLOWED_ORIGINS`

## Ce qui n'est pas dans le pipeline

Le **frontend** (Playfield et Backglass) n'est pas déployé via ce pipeline. Les deux applications React tournent directement sur les machines physiques de la borne si j'ai bien compris hein. Un pipeline de CI (lint, tests, build) existe sur ces repos pour garantir la qualité du code, mais aucun déploiement cloud n'est nécessaire.

Le **code ESP32** est flashé directement sur les microcontrôleurs via PlatformIO. Ce processus est hors scope du pipeline CI/CD.

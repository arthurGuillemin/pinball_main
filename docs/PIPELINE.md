# Pipeline CI/CD — Projet Flipper

## Architecture de déploiement

Le projet se décompose en trois parties : Playfield, Backglass et Backend. Les deux fronts tournent directement sur la machines physiques si j'ai bine compris , ils n'ont pas vocation à être déployés dans le cloud. Seul le backend Node.js est déployé sur Azure, car il expose l'API REST et le serveur WebSocket consommés par les écrans et les ESP32.


## Pipeline backend — du commit à la prod

```
push/pull_request main
    │
    ├── 1. Tests
    ├── 2. Scan des scerets - gitguardian
    ├── 2. Build image Docker
    ├── 3. Push Docker Hub
    ├── 4. Scan de l'image Trivy
    └── 5. Restart Azure Web App 
```

Chaque étape est bloquante — un job qui échoue empêche le déploiement. L'environnement GitHub `production` ajoute une un reviewer quui doit approuver avant que le deploy ne s'exécute.

## Pipeline frontend — CI uniquement

Les repos Playfield et Backglass ont un pipeline de CI (lint + build ) qui se déclenche sur chaque push/pull request sur les branche main et dev , une autre CI qui build et push image Docker Hub  est trigger par un push/pull request seulement sur le main pour pouvoir lancer facilement le front sur la borne avecdocker sans avoir à installer Node ou builder localement.

---

## Choix techniques

### GitHub Actions
Intégration native avec GitHub, pas de serveur CI à maintenir, gestion des secrets directement dans l'interface. Déclenchement automatique sur chaque push

### Docker + Dockerfile multi-stage
Le multi-stage exclut les devDependencies de l'image finale — Vitest, ESLint et les outils de build ne se retrouvent pas en production , le build cible linux/amd64 et linux/arm6 pour la compatibilité Azure et Apple Silicon

### Docker Hub
Registry pour les images publiques , accessible directement par Azure sans configuration d'auth en plus. Permet aussi de distribuer les images front sur la borne physique

### Terraform
L'infrastructure Azure est décrite en code versionné dans Git. Toute modification passe par une Pull Request et laisse une trace dans l'historique.

### Azure Linux Web App
Supporte nativement les WebSockets — indispensable pour la communication temps réel. Gère le scaling et le redémarrage automatique sans serveur à administrer.

### GitGuardian
Surveille chaque push pour détecter les secrets exposes accidentellement  -> Intégration native GitHub + job dédié dans le pipeline CI

### Trivy
Scan de vulnérabilités sur l'image Docker à chaque deploy

---

## Outils écartés et pourquoi

**Kubernetes** — conçu pour orchestrer des dizaines de microservices sur plusieurs nœuds. Le projet déploie un seul service Node.js sur une borne physique. Azure Web App gère déjà l'orchestration

**Helm** — gestionnaire de packages pour Kubernetes. Sans Kubernetes pad d' utilité

**ArgoCD** — GitOps pour Kubernetes mm raison que K8s

---

## Gestion des secrets

Aucun secret commité dans le repository. Les variables sensibles sont gérées à deux niveaux : GitHub Actions Secrets pour les credentials Docker Hub et Azure, variables d'environnement Azure injectées par Terraform pour les credentials Supabase.

Le fichier terraform.tfvars et les fichiers .tfstate sont dans le .gitignore et le .dockerignore.

---

## Hors scope

Le code ESP32 est flashé directement sur les microcontrôleurs via PlatformIO — hors scope du pipeline CI/CD.

# Cahier des charges

# Projet de fin d’étude

# Flipper

## Année 2025-2026


## Sommaire

- 1. Vision du projet
   - Présentation du projet
- 2. Objectifs et périmètre
      - Fonctionnalités principales attendues
      - Fonctionnalités bonus envisagées
   - Non-Objectifs
   - Personas
- 3. Use Cases
      - Cas 1
      - Cas 2
      - Cas 3
- 4. Architecture technique
- 5. Diagrames UML
- 6. Stack technique
- 7. Risques et Contraintes techniques
   - Contraintes techniques
   - Risques identifiés
   - Critères de réussite
- 8. Conventions équipe
   - Stratégie Git
   - Règles de fusion
   - Commits
   - Qualité du code
   - Test
- 9. Roadmap et questions ouvertes
   - Questions ouvertes
   - Roadmap
- 10. Arborescence et contenu du projet
   - Arborescence
      - Repositories du projet
      - Schéma d’arboresence
- 11. Description graphique du projet
   - Spécifications d’affichage
   - Lien du figma
- Annexe

## 1. Vision du projet

### Présentation du projet

L'objectif est de concevoir et développer un flipper virtuel interactif, reproduisant fidèlement
les mécaniques d’un flipper physique dans un environnement numérique, afin de moderniser
une expérience de jeu traditionnelle.

L’objectif est de créer une expérience immersive mêlant : rendu graphique 3D, simulation
physique réaliste, communication en temps réel, interaction via contrôleurs (clavier / IoT).

### Description d’un flipper

Un flipper est une machine de jeu composée d’un plateau rempli d’obstacles, de cibles et de
mécanismes. Le joueur doit empêcher la bille de tomber tout en maximisant son score grâce
aux interactions avec les différents éléments du plateau.

Ce projet vise à transposer ces mécaniques dans un environnement numérique.


## 2. Objectifs et périmètre

Le projet vise à concevoir une table de flipper complète reposant sur trois applications
distinctes, synchronisées en temps réel :

- **Playfield** : affichage du plateau de jeu en 3D
- **Backglass** : affichage du score et des informations de jeu
- **DMD** (Dot Matrix Display) : affichage des messages et feedback joueur

#### Fonctionnalités principales attendues

- Simulation physique réaliste de la bille (collisions, gravité, rebonds)
- Interaction avec les flippers
- Gestion du score et des événements de jeu
- Synchronisation temps réel entre les applications
- Intégration d’un système de contrôleurs ( IoT)

#### Fonctionnalités bonus envisagées
- Mode deux joueurs
- Deuxième niveau
- Effets visuels avancés
- Effets sonores immersifs
- Éléments d’intelligence artificielle

### Non-Objectifs :

- Pas de multijoueur en ligne distant
- Pas de version mobile

### Personas :

- **Jean** (Joueur nostalgique) **:** 46 ans, ancien habitué des flippers mécaniques des
    cafés et salles d’arcade. Recherche une expérience fidèle avec une physique réaliste
    et des sensations authentiques. Sensible à l’immersion, aux sons et au ressenti du
    jeu.
- **Léa** (Joueuse découverte / curieuse) **:** 19 ans, étudiante, attirée par les jeux visuels
    et interactifs. Souhaite découvrir le flipper via une expérience accessible et intuitive.
    Apprécie les effets visuels dynamiques et la gratification immédiate.


## 3. Use Cases :

#### Cas 1 :

|Nom                        | Lancer une Partie                                                           |
|---------------------------|-----------------------------------------------------------------------------|
| Acteur                    | Joueur                                                                      |
| Objectif                  | démarrer une Nouvelle Partie                                                |
| Préconditions             | Machine Allumée et déployée<br>Machine libre (pas de joueur)                |
| Déclencheur               | Clique le bouton START                                                      |
| Scénario nominatif        | Animation de Bienvenue                                                      |
|                           | Score à Zéro                                                                |
|                           | La balle entre en la table (rampe de tirette)                               |
|                           | Nombre de vie défini                                                         |
| Postconditions            | le jeu commence                                                             |
|                           | la balle bouge en table                                                     |
| Extensions/Exceptions     | bouton ne marche pas<br>erreur inconnue                                     |
| Classes impliquées        | Game, Physics Engine, Ball, Bar, ScoreManager                               |


#### Cas 2 :

| Nom                       | Interaction balle / bumper                                                  |
|---------------------------|-----------------------------------------------------------------------------|
| Acteur principal          | Joueur (via interaction physique)                                           |
| Objectif                  | Gagner des points lors d’une collision                                      |
| Préconditions             | Une partie est en cours et la balle est active                              |
| Déclencheur               | La balle entre en collision avec un bumper                                  |
| Scénario nominatif        | 1. La balle se déplace sous l’effet de la gravité                           |
|                           | 2. Le moteur physique détecte une collision                                 |
|                           | 3. Collision entre Ball et Bumper                                           |
|                           | 4. Le système applique une force de rebond                                  |
|                           | 5. Une animation et un son sont déclenchés                                  |
|                           | 6. Des points sont ajoutés au score                                         |
|                           | 7. Le score est mis à jour à l’écran                                        |
| Postconditions            | Le score est augmenté et la balle continue son mouvement                    |
| Extensions/Exceptions     | - Multiplicateur actif -> bonus de points                                   |
|                           | - Combo actif -> score majoré                                               |
| Classes impliquées        | Physics Engine, Ball, Bumper, ScoreManager, Game                            |


#### Cas 3 :

| Nom                       | High Score / Le Joueur écrit son surnom sur le hall of Fame                 |
|---------------------------|-----------------------------------------------------------------------------|
| Acteur                    | Joueur                                                                      |
| Objectif                  | Réaliser un score parmi les 10 premiers                                     |
| Préconditions             | Machine Allumée, jeu démarré                                                |
| Déclencheur               | Avoir un Score parmi les 10 premiers                                        |
| Scénario nominatif        | - Jeu démarré                                                               |
|                           | - Le joueur réalise un haut score grâce au jeu ou plusieurs bonus           |
|                           | - Le jeu est terminé (Game Over)                                            |
|                           | - Le score affiché                                                           |
|                           | - Animation de félicitation                                                 |
| Postconditions            | - Score parmi les 10 premiers                                               |
|                           | - Animation de félicitation                                                 |
| Extensions/Exceptions     | - Le joueur finit la partie en 11ème place ou plus                           |
|                           | - Joueur refuse de mettre son surnom                                        |
| Classes impliquées        | Game, Physics Engine, Ball, Bar, ScoreManager, Animation                    |


## 4. Architecture technique
cd ./annexes/schema_architecture_technique.png

## 5. Diagrames UML
cd ./annexes/schema_uml.png
cd ./annexes/schema_diagramme_d_etat.png

## 6. Stack technique
cd ./annexes/schema_collision_utilisation.png

| Composant           | Techno                          | Justification                                                         |
|---------------------|---------------------------------|----------------------------------------------------------------------|
| Playfield            | React, Three.js, RapierJS ou    | React assure une architecture modulaire. Three.js permet le rendu 3D |
|                     | CannonJS ou p2.js, Blender      | web. Le moteur physique n’est pas encore définitivement choisi, on    |
|                     |                                 | réfléchit à la solution la plus adaptée au projet. Blender est        |
|                     |                                 | utilisé pour la création et l'exportation des modèles 3D.            |
| Backglass           | React, Three.js                 | Architecture cohérente avec le Playfield. Permet animations et        |
|                     |                                 | éléments visuels dynamiques.                                         |
| DMD                 | React                           | Adapté à l’affichage 2D temps réel (scores, états, animations).       |
|                     |                                 | Léger et performant.                                                 |
| Bridge              | Node.js, WebSocket              | Permet la communication temps réel entre les modules.                |
| Backend Scores / DB | Node.js, Supabase               | Supabase simplifie la gestion de la base de données et la persistance.|
|                     |                                 | Intégration rapide avec Node.js.                                     |
| ESP32               | C++                             | Permet le contrôle du matériel et la gestion des entrées physiques.  |


## 7. Risques et Contraintes techniques

### Contraintes techniques

Le projet devra respecter les contraintes suivantes :

- Trois écrans physiques imposés
- Une communication en temps réel stable
- Une simulation physique crédible
- Une séparation claire des responsabilités
- Un code modulaire et maintenable

### Risques identifiés
| Risques              | Probabilité      | Impact      | Mitigation                             |
|----------------------|------------------|-------------|----------------------------------------|
| Physique instable    | Moyenne/Forte    | Très fort   | Testers différents moteurs physiques   |
| Latence du WebSocket | Moyenne          | Fort        | Tests en local                         |
| Performance 3D       | Moyenne          | Moyen       | Optimisation des collisions            |

### Critères de réussite

Le projet sera considéré comme réussi si :

- Le gameplay est fonctionnel
- La physique est crédible
- Les applications sont synchronisées
- L’expérience utilisateur est fluide
- L’architecture est propre et modulaire


## 8. Conventions équipe

### Stratégie Git

Le projet adopte une stratégie GitFlow :

- Branche **main** : branche stable contenant uniquement du code validé. Aucun push
    direct n’est autorisé.
- Branche **dev** : branche d’intégration des nouvelles fonctionnalités.
- Branches **feature** : branche de travaille
    - feature/<feature>
    - bugfix/<bugfix>

### Règles de fusion

- Aucun merge direct vers main
- Minimum une review obligatoire par Pull Request
- Continuous Integration obligatoire avant validation du merge

### Commits

Les commits suivent la norme Conventional Commits :

```
feat: add bumper collision
fix: correct score sync
docs: update CDC
```
### Qualité du code

Afin d’assurer la cohérence et la qualité du code :

- Utilisation de ESLint (linting)
- Utilisation de Prettier (formatage)
- Vérifications automatiques via Husky (pre-commit)

### Test

Les tests sont obligatoires sur le backend.


## 9. Roadmap et questions ouvertes

### Questions ouvertes :

- Rapierjs , CannonJs ou p2.js?
- Architecture hardware !!
- Utilisation de React Three Fiber?
- Partie ia : Ollama ou Hugging face

### Roadmap
| Semaines | À faire                                                                                                            |
|----------|--------------------------------------------------------------------------------------------------------------------|
| S1       | Cahier des charges, Setup Github, WebSocket simple, Setup ThreeJS / Moteur physique                                |
| S2       | Frontend : Bille gravité, Collisions (Bridge, Flipper gauche/droite, Bumpers, Slingshot, Launcher), Backglass      |
|          | (réception événements, affichage scores)                                                                            |
|          | Backend : gestion d'états, communication client                                                                    |
|          | IOT : communication ESP32 et WebSocket                                                                             |
| S3       | Frontend : Squelette fonctionnel, Atouts (60%), GAME OVER                                                          |
|          | Backend : module IA                                                                                                |
| S4       | Frontend : Fin des assets, terminer Backglass                                                                      |
|          | Backend : Gestion multi-joueurs et jeux contre bot                                                                 |
| S5       | IOT : Mapping bouton ESP32, Gestion solénoïdes, Gestion de la latence                                              |
|          | Frontend : DMD                                                                                                     |
| S6       | Frontend : Texture, Animations, Musiques, Sons                                                                     |
|          | Backend / IOT : Test, debug                                                                                        |
|          | Présentation                                                                                                       |
| S7       | Frontend : Texture, Animations, Musiques, Sons                                                                     |
|          | Backend / IOT : Test, debug                                                                                        |
|          | Présentation                                                                                                       |


Suivi : [http://github.com/users/arthurGuillemin/projects/](http://github.com/users/arthurGuillemin/projects/)


## 10. Arborescence et contenu du projet

### Arborescence

Le projet adopte une organisation en polyrepository
**(** https://github.com/arthurGuillemin/pinball_main), permettant une séparation claire des
responsabilités et une modularité accrue.

#### Repositories du projet

- **Frontend,** interface utilisateur et rendu graphique :
    - Playfield : https://github.com/arthurGuillemin/pinball_playglass
    - Backglass : https://github.com/arthurGuillemin/pinball_backglass
    - DMD : https://github.com/arthurGuillemin/pinball_dmd
- **Backend :** https://github.com/arthurGuillemin/pinball_backend
    Gestion des communications temps réel et logique métier , Interface entre le
    système IoT et l’application principale
- **ESP32 :** https://github.com/arthurGuillemin/pinball_esp
    Gestion des périphériques physiques (contrôleurs / solénoïdes)

#### Schéma d’arboresence
cd ./annexes/schema_arboresence.png


## 11. Description graphique du projet

Le projet devra proposer :

- Une interface claire et lisible
- Un design cohérent (thème visuel)
- Des feedbacks visuels explicites
- Une expérience immersive

### Spécifications d’affichage

L’interface devra être adaptée aux dimensions physiques des différents écrans du flipper :

- **Playglass** : 52,5 cm × 89 cm
- **Backglass** : 69 cm × 39 cm
- **DMD** : 34 cm × 19 cm

## Annexe :

### Lien du figma :
https://www.figma.com/design/N4ktQtBApoL2DtJ6cdA2Yz/Flipper?node-id=0-1&p=f&m=dra
w

## Lien du drive assets de cuphead :
http://drive.google.com/drive/folders/1IUgVKfxIylvP6BZBiQ5GIEFuWJTuULf7


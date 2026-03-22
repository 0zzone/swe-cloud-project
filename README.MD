# SWE Cloud Project

Projet de micro-services cloud natif réalisé par **Mattéo BONNET** et **Ylan HEBRON** pour Software Engineering for the Cloud.

## 1. Nos labs

Mattéo BONNET : ![](https://www.zupimages.net/up/26/12/nl2x.png)
Ylan HEBRON : ![Capture 1](https://www.zupimages.net/up/26/12/jjgv.png)

## 2. Stack technique

- Base de données : PostgreSQL (un service DB par micro-service)
- ORM : Prisma
- Backend : Node.js, TypeScript
- Services backend : image-service, pdf-service
- Frontend : React, TypeScript, Vite
- Conteneurisation : Docker
- Orchestration locale : Kubernetes
- Réseau/ingress : Gateway + Virtual Services + Destination Rules (style service mesh)

## 3. Architecture du projet

Le projet est composé de 3 blocs applicatifs principaux :

1. image-service
2. pdf-service
3. front (interface utilisateur)

Ainsi qu'un dossier d'infrastructure Kubernetes sous `k8s/` contenant tous les manifestes de déploiement, services, ingress, etc.

## 4. Fonctionnalités

- Upload/traitement d'images via image-service
- Génération/traitement PDF via pdf-service
- Interface frontend pour consommer les API
- Persistance des données avec PostgreSQL et Prisma

## 5. Mapping avec le barème/progression conseillée

### Étape 10/20 - Un seul service en local

- Mini application backend codée
- Dockerfile créé
- Image Docker publiable
- Déploiement Kubernetes
- Service Kubernetes

### Étape 12/20 - Gateway locale

- Routage vers service(s) via gateway/ingress ou service mesh

### Étape 14/20 - Deuxième service

- Deux micro-services distincts
- Communication inter-services

### Étape 16/20 - Base de données

- PostgreSQL intégré au projet
- Schéma géré via les migrations Prisma

### Étape 18/20 (bonus) - Cloud et/ou sécurisation du cluster

- Déploiement cloud (optionnel)
- Durcissement/sécurisation du cluster (optionnel)

## 6. Lancement en local

### 6.1 Backend - image-service

```bash
cd backend/image-service
pnpm install
pnpm dev
```

### 6.2 Backend - pdf-service

```bash
cd backend/pdf-service
pnpm install
pnpm dev
```

### 6.3 Frontend

```bash
cd front
pnpm install
pnpm dev
```

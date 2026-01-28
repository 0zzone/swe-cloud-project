#!/bin/bash

echo "🚀 Déploiement local avec Minikube"
echo "==================================="

# Vérifier que Minikube est démarré
if ! minikube status &> /dev/null; then
    echo "⚠️  Minikube n'est pas démarré. Démarrage..."
    minikube start
fi

# S'assurer que l'addon ingress est activé
echo "🧩 Activation de l'addon ingress (si nécessaire)..."
minikube addons enable ingress

# Appliquer les configurations Kubernetes
echo "☸️  Application des configurations Kubernetes..."
kubectl apply -f image-deployment.yml
kubectl apply -f pdf-deployment.yml
kubectl apply -f image-service.yml
kubectl apply -f pdf-service.yml

# Attendre que les pods soient prêts
echo "⏳ Attente du démarrage des pods..."
kubectl wait --for=condition=ready pod -l app=image-service --timeout=45s
kubectl wait --for=condition=ready pod -l app=pdf-service --timeout=45s

# Appliquer l'Ingress
echo "✅ Application de l'Ingress..."
kubectl apply -f ingress.yml

echo "Forwarding ingress-nginx-controller port 8080 to 80"
kubectl -n ingress-nginx port-forward svc/ingress-nginx-controller 8080:80
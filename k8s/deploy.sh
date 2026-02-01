#!/bin/bash

echo "🚀 Déploiement local avec Minikube"
echo "==================================="

# Vérifier que Minikube est démarré
if ! minikube status &> /dev/null; then
    echo "⚠️  Minikube n'est pas démarré. Démarrage..."
    minikube start
fi

# Istio installation
curl -L https://istio.io/downloadIstio | sh -
cd istio-*
export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo -y
cd ..

# Appliquer les configurations Kubernetes
echo "☸️  Application des configurations Kubernetes..."
kubectl apply -f gateway.yml
kubectl apply -f virtual-services.yml
kubectl apply -f image-deployment.yml
kubectl apply -f pdf-deployment.yml
kubectl apply -f image-service.yml
kubectl apply -f pdf-service.yml

# Attendre que les pods soient prêts
echo "⏳ Attente du démarrage des pods..."
kubectl wait --for=condition=ready pod -l app=image-service --timeout=45s
kubectl wait --for=condition=ready pod -l app=pdf-service --timeout=45s

echo "Forwarding istio-ingressgateway port 8080 to 80"
kubectl port-forward -n istio-system svc/istio-ingressgateway 8080:80
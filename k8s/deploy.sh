#!/bin/bash

echo "🚀 Déploiement local avec Minikube"
echo "==================================="

# Vérifier que Minikube est démarré
if ! minikube status &> /dev/null; then
    echo "⚠️  Minikube n'est pas démarré. Démarrage..."
    minikube start
fi

# Istio installation
rm -rf istio-*
curl -L https://istio.io/downloadIstio | sh -
cd istio-*
export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo -y
cd ..

# DB
kubectl apply -f postgres-image-deployment.yml
kubectl apply -f postgres-pdf-deployment.yml
echo "⏳ Attente du démarrage des pods (DB)..."
kubectl wait --for=condition=ready pod -l app=postgres-image --timeout=45s
kubectl wait --for=condition=ready pod -l app=postgres-pdf --timeout=45s

# Appliquer les configurations Kubernetes
echo "☸️  Application des configurations Kubernetes..."
kubectl apply -f gateway.yml
kubectl apply -f virtual-services.yml
kubectl apply -f image-deployment.yml
kubectl apply -f pdf-deployment.yml
kubectl apply -f image-service.yml
kubectl apply -f pdf-service.yml
kubectl apply -f destination-rules.yml

# Attendre que les pods soient prêts
echo "⏳ Attente du démarrage des pods..."
kubectl wait --for=condition=ready pod -l app=image-service --timeout=45s
kubectl wait --for=condition=ready pod -l app=pdf-service --timeout=45s

echo "Forwarding istio-ingressgateway port 8080 to 80"
kubectl port-forward -n istio-system svc/istio-ingressgateway 8080:80
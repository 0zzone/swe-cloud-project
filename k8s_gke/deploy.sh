#!/bin/bash
set -e

echo "🚀 Déploiement sur GKE"
echo "======================"

# ── Chargement du fichier .env ────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

if [[ ! -f "$ENV_FILE" ]]; then
    echo "❌ Fichier .env introuvable."
    echo "   Crée-le à partir du modèle : cp .env.example .env"
    exit 1
fi

set -a
# shellcheck source=.env
source "$ENV_FILE"
set +a

# ── Valeurs par défaut ────────────────────────────────────────────────────────
GKE_REGION="${GKE_REGION:-us-central1}"
DB_USER="${DB_USER:-user}"
DB_IMAGE_NAME="${DB_IMAGE_NAME:-imagedb}"
DB_PDF_NAME="${DB_PDF_NAME:-pdfdb}"

# ── Prérequis ────────────────────────────────────────────────────────────────
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl n'est pas installé."
    echo "   https://kubernetes.io/docs/tasks/tools/"
    exit 1
fi

if ! command -v gcloud &> /dev/null; then
    echo "❌ gcloud CLI n'est pas installé."
    echo "   https://cloud.google.com/sdk/docs/install"
    exit 1
fi

if [[ -z "$GKE_CLUSTER" || -z "$GKE_PROJECT" ]]; then
    echo "❌ Variables GKE manquantes dans .env :"
    echo "   GKE_CLUSTER=<nom-du-cluster>"
    echo "   GKE_PROJECT=<project-id>"
    exit 1
fi

if [[ -z "$DB_PASSWORD" ]]; then
    echo "❌ DB_PASSWORD est requis dans .env"
    exit 1
fi

# ── Connexion au cluster GKE ─────────────────────────────────────────────────
echo "🔑 Récupération des credentials GKE..."
gcloud container clusters get-credentials "$GKE_CLUSTER" \
    --region "$GKE_REGION" \
    --project "$GKE_PROJECT"

# ── Installation Istio ────────────────────────────────────────────────────────
echo "🔧 Installation d'Istio..."
rm -rf istio-*
curl -L https://istio.io/downloadIstio | sh -
cd istio-*
export PATH=$PWD/bin:$PATH
istioctl install --set profile=demo --set components.cni.enabled=false -y
cd ..

# GKE Autopilot bloque NET_ADMIN (requis par istio-init) → désactivation de
# l'injection de sidecar sur le namespace default. L'ingress gateway continue
# d'assurer le routage via Gateway + VirtualService.
echo "🔧 Désactivation de l'injection de sidecar Istio (GKE Autopilot)..."
kubectl label namespace default istio-injection=disabled --overwrite

# ── Secrets (générés depuis les variables d'env, jamais stockés dans un fichier)
echo "🔒 Création des secrets Kubernetes..."
kubectl create secret generic postgres-image-secret \
    --from-literal=POSTGRES_USER="$DB_USER" \
    --from-literal=POSTGRES_PASSWORD="$DB_PASSWORD" \
    --from-literal=POSTGRES_DB="$DB_IMAGE_NAME" \
    --from-literal=DATABASE_URL="postgresql://${DB_USER}:${DB_PASSWORD}@postgres-image:5401/${DB_IMAGE_NAME}?schema=public" \
    --dry-run=client -o yaml | kubectl apply -f -

kubectl create secret generic postgres-pdf-secret \
    --from-literal=POSTGRES_USER="$DB_USER" \
    --from-literal=POSTGRES_PASSWORD="$DB_PASSWORD" \
    --from-literal=POSTGRES_DB="$DB_PDF_NAME" \
    --from-literal=DATABASE_URL="postgresql://${DB_USER}:${DB_PASSWORD}@postgres-pdf:5402/${DB_PDF_NAME}?schema=public" \
    --dry-run=client -o yaml | kubectl apply -f -

# ── DB ────────────────────────────────────────────────────────────────────────
kubectl apply -f postgres-image-deployment.yml
kubectl apply -f postgres-pdf-deployment.yml
echo "⏳ Attente du démarrage des pods (DB)..."
kubectl rollout status deployment/postgres-image --timeout=300s
kubectl rollout status deployment/postgres-pdf --timeout=300s

# ── Application ───────────────────────────────────────────────────────────────
echo "☸️  Application des configurations Kubernetes..."
kubectl apply -f gateway.yml
kubectl apply -f virtual-services.yml
kubectl apply -f front-deployment.yml
kubectl apply -f image-deployment.yml
kubectl apply -f pdf-deployment.yml
kubectl apply -f front-service.yml
kubectl apply -f image-service.yml
kubectl apply -f pdf-service.yml
kubectl apply -f destination-rules.yml

echo "⏳ Attente du démarrage des pods..."
kubectl rollout status deployment/front-app --timeout=300s
kubectl rollout status deployment/image-service --timeout=300s
kubectl rollout status deployment/pdf-service --timeout=300s

# ── Récupération de l'IP externe ──────────────────────────────────────────────
echo "⏳ Attente de l'IP externe de l'ingressgateway..."
for i in {1..24}; do
    EXTERNAL_IP=$(kubectl get svc istio-ingressgateway -n istio-system \
        -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || true)
    if [[ -n "$EXTERNAL_IP" ]]; then break; fi
    echo "   ... ($i/24)"
    sleep 10
done

if [[ -n "$EXTERNAL_IP" ]]; then
    echo "✅ Application accessible sur : http://$EXTERNAL_IP"
    echo "   /image → image-service"
    echo "   /pdf   → pdf-service"
else
    echo "⚠️  IP externe non encore disponible. Vérifiez avec :"
    echo "   kubectl get svc istio-ingressgateway -n istio-system"
fi

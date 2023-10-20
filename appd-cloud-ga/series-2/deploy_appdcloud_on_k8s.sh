#!/bin/bash
###############################################################################
# This script will deploy AppD Cloud Operater and Collectors to the 
# current profile. 
# 
# Ensure the following environment vaiables are set properly before running
# APPD_CLOUD_CLIENT_ID
# APPD_CLOUD_CLIENT_SECRET
#
###############################################################################
if [[ -z ${APPD_CLOUD_CLIENT_ID+x} ]]; then
    echo "APPD_CLOUD_CLIENT_ID is not set" && exit 1
elif [[ -z ${APPD_CLOUD_CLIENT_SECRET+x} ]]; then
    echo "APPD_CLOUD_CLIENT_SECRET is not set" && exit 1
fi
set -x #echo on
cd "$(dirname "$0")"
kubectl create namespace cnao
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.0/cert-manager.yaml
sleep 90
helm repo add appdynamics-cloud-helmcharts https://appdynamics.jfrog.io/artifactory/appdynamics-cloud-helmcharts/
# Update to the latest chart
helm repo update 
helm install cnao-operators appdynamics-cloud-helmcharts/appdynamics-operators -n cnao \
-f operators-values.yaml \
--set global.clusterName=gke-lab-cluster-$USER \
--set fso-agent-mgmt-client.oauth.clientId=$APPD_CLOUD_CLIENT_ID \
--set fso-agent-mgmt-client.oauth.clientSecret=$APPD_CLOUD_CLIENT_SECRET \
--wait 
kubectl -n cnao get pods
sleep 5
# add if needed: --set appdynamics-cloud-db-collector.dbMonitoringConfigs[0].password=$MYSQL_ROOT_PASSWORD \
helm install cnao-collectors appdynamics-cloud-helmcharts/appdynamics-collectors -n cnao \
-f collectors-values.yaml \
--set global.clusterName=gke-lab-cluster-$USER \
--set appdynamics-cloud-db-collector.appdCloudAuth.clientId=$APPD_CLOUD_CLIENT_ID \
--set appdynamics-cloud-db-collector.appdCloudAuth.clientSecret=$APPD_CLOUD_CLIENT_SECRET \
--set appdynamics-otel-collector.clientId=$APPD_CLOUD_CLIENT_ID \
--set appdynamics-otel-collector.clientSecret=$APPD_CLOUD_CLIENT_SECRET \
--set appdynamics-security-collector.panoptica.controller.agentID=$APPD_PANOPTICA_AGENT_ID \
--set appdynamics-security-collector.panoptica.controller.secret.sharedSecret=$APPD_PANOPTICA_AGENT_SECRET 
kubectl -n cnao get all
say -v "Samantha" "appd cloud deployment completed"

#!/bin/bash
kubectl delete svc -n jen-ns jenkins-lb
kubectl delete deploy -n jen-ns jenkins
kubectl delete pvc -n jen-ns jenkins-pv-claim
kubectl delete pv jenkins-pv
kubectl delete clusterrolebinding jenkins-admin
kubectl delete clusterrole jenkins-admin
kubectl delete sa -n jen-ns jenkins-admin
kubectl delete ns jen-ns
kubectl delete ns app
echo "Cleaning Done"

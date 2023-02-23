#!/bin/bash
kubectl apply -f 1-namespace.yaml ;
sleep 5 ;
kubectl apply -f 2-serviceAccount.yaml ;
sleep 5 ;
kubectl apply -f 3-ClusterRole.yaml ;
sleep 5 ;
kubectl apply -f 4-ClusterRoleBinding.yaml ;
sleep 5 ;
kubectl apply -f 5-jenkins-dep.yaml ;
sleep 5 ;
kubectl apply -f 6-service.yaml ;
sleep 5 ;
kubectl apply -f /home/ubuntu/k8s/1-namespace.yaml ;
sleep 5 ;
kubectl apply -f /home/ubuntu/k8s/2-serviceAccount.yaml ;
sleep 5 ;
kubectl apply -f /home/ubuntu/k8s/3-ClusterRole.yaml ;
sleep 5 ;
kubectl apply -f /home/ubuntu/k8s/4-ClusterRoleBinding.yaml ;
sleep 5 ;
kubectl apply -f /home/ubuntu/k8s/5-jenkins-dep.yaml ;
sleep 5 ;
kubectl apply -f /home/ubuntu/k8s/6-service.yaml ;
sleep 5 ;
echo "DONE" > script_runned_succefully.finish ;
/home/ubuntu/k8s/
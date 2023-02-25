#!/bin/bash
echo "Done" > /home/ubuntu/start.script
/home/ubuntu/bin/kubectl apply -f /home/ubuntu/k8s/1-namespace.yaml ;
/home/ubuntu/bin/kubectl apply -f /home/ubuntu/k8s/2-serviceAccount.yaml ;
/home/ubuntu/bin/kubectl apply -f /home/ubuntu/k8s/3-ClusterRole.yaml ;
/home/ubuntu/bin/kubectl apply -f /home/ubuntu/k8s/4-ClusterRoleBinding.yaml ;
/home/ubuntu/bin/kubectl apply -f /home/ubuntu/k8s/5-pv-volume.yaml ;
/home/ubuntu/bin/kubectl apply -f /home/ubuntu/k8s/6-pv-claim.yaml ;
/home/ubuntu/bin/kubectl apply -f /home/ubuntu/k8s/7-jenkins-dep.yaml ;
/home/ubuntu/bin/kubectl apply -f /home/ubuntu/k8s/8-service.yaml ;
# /home/ubuntu/bin/kubectl apply -f /home/ubuntu/k8s/9-app-deployment.yaml ;
# /home/ubuntu/bin/kubectl apply -f /home/ubuntu/k8s/10-app service.yaml;
echo "Done" > /home/ubuntu/end.script
cat /home/ubuntu/start.script /home/ubuntu/end.script

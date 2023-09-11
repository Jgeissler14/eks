#!/bin/bash

EKS_CLUSTER_NAME=$(terraform output -raw cluster_name)
aws eks --region us-east-1 update-kubeconfig --name $EKS_CLUSTER_NAME
kubectl config get-contexts
kubectl config use-context $EKS_CLUSTER_NAME
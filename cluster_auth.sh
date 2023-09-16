#!/bin/bash

EKS_CLUSTER_NAME=$(terraform output -raw cluster_name)
aws eks --region us-east-1 update-kubeconfig --name $EKS_CLUSTER_NAME
AWS_ACCOUNT_NUMBER=$(aws sts get-caller-identity --query Account --output text)
kubectl config use-context arn:aws:eks:us-east-1:$AWS_ACCOUNT_NUMBER:cluster/$EKS_CLUSTER_NAME
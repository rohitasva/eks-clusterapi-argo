#!/bin/bash
#

function key_pair {
    if test -f ~/.ssh/capi-eks.pem; then
        echo "AWS key pair capi-eks.pem exists in Region: $1"
    else
        echo "Creating AWS key pair capi-eks"
        aws ec2 create-key-pair --key-name capi-eks --region $1 --query 'KeyMaterial' --output text > ~/.ssh/capi-eks.pem
    fi
}

export AWS_ACCOUNT_ID=663445957666
export AWS_REGION=us-west-2

export EKS=true
export EXP_MACHINE_POOL=true
export CAPA_EKS_IAM=true

key_pair $AWS_REGION

export AWS_SSH_KEY_NAME=capi-eks
export AWS_B64ENCODED_CREDENTIALS=$(clusterawsadm bootstrap credentials encode-as-profile)
export AWS_CONTROL_PLANE_MACHINE_TYPE=t3.large
export AWS_NODE_MACHINE_TYPE=t3.large

echo "Installing AWS cluster providers on the cluster"
clusterctl init --infrastructure aws

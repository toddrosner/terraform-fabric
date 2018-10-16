# terraform-fabric
Hyperledger Fabric on GKE built with Terraform

1. Setup your GCP project and establish your JSON credentials.
2. Navigate to `deployments/development/us-west2/compute/kubernetes-engine/fabric-cluster/`.
3. Update `config.tf` to point to your project JSON credentials file.
4. Run `make plan` to prove Terraform will work.
5. Run `make apply` to deploy the GKE cluster and node pools.
6. Access the GCP Kubernetes Engine console to view your cluster.
7. Click the `Connect` button beside your cluster name, and copy the gcloud command.
8. Paste the gcloud command into your terminal to establish the kubectl configuration for the cluster.
9. Test cluster access by running `kubectl cluster-info`.
10. Run the `deploy-resources.sh` script to deploy all namespaces, deployments, services, etc.

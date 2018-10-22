# terraform-fabric
Hyperledger Fabric on GKE built with Terraform

1. Setup your GCP project and establish your JSON credentials.
2. Navigate to `deployments/development/us-west1/compute/kubernetes-engine/clusters/fabric/`.
3. Update `config.tf` to point to your project JSON credentials file.
4. Run `make plan` to prove Terraform will work.
5. Run `make apply` to deploy the GKE cluster and node pools.
6. Access the GCP Kubernetes Engine console to view your cluster.
7. Click the `Connect` button beside your cluster name, and copy the gcloud command.
8. Paste the gcloud command into your terminal to establish the kubectl configuration for the cluster.
9. Test cluster access by running `kubectl cluster-info`.
10. Choose if you want storage using a GCE disk (dev) or Filestore (prod).
    - If GCE disk is chosen, navigate to `deployments/development/us-west1/compute/compute-engine/disks/nfs-disk/`.
    - If Filestore is chosen, navigate to `deployments/development/us-west1/storage/filestore/shared-storage/`.
11. Run `make plan` to prove Terraform will work.
12. Run `make apply` to deploy storage solution.
13. Run the `deploy-resources.sh` script to deploy all namespaces, deployments, services, etc.
    - Note: make sure your storage type selected is used for the argument to the script.

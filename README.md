# terraform-fabric
Hyperledger Fabric on GKE built with Terraform

1. Setup a GCP project named `terraform-fabric` https://cloud.google.com/resource-manager/docs/creating-managing-projects.
2. Establish a service account and JSON credentials https://cloud.google.com/docs/authentication/getting-started.
3. Download and install the Google Cloud SDK (gcloud) https://cloud.google.com/sdk/docs/quickstarts.
4. Navigate to `deployments/development/us-west1/compute/kubernetes-engine/clusters/fabric/`.
5. Update `config.tf` to point to your project JSON credentials file.
6. Run `make plan` to prove Terraform will work.
7. Run `make apply` to deploy the GKE cluster and node pools.
8. Access the GCP Kubernetes Engine console to view your cluster.
9. Click the `Connect` button beside your cluster name, and copy the gcloud command.
10. Paste the gcloud command into your terminal to establish the kubectl configuration for the cluster.
11. Test cluster access by running `kubectl cluster-info`.
12. Choose if you want storage using a GCE disk (dev) or Filestore (prod).
    - If GCE disk is chosen, navigate to `deployments/development/us-west1/compute/compute-engine/disks/nfs-disk/`.
    - If Filestore is chosen, navigate to `deployments/development/us-west1/storage/filestore/shared-storage/`.
13. Update `config.tf` to point to your project JSON credentials file.
14. Run `make plan` to prove Terraform will work.
15. Run `make apply` to deploy storage solution.
16. Navigate to `manifests/`.
17. Run the `deploy-resources.sh` script to deploy all namespaces, deployments, services, etc.
    - Note: make sure your chosen storage type is used as an argument to the script, i.e. `deploy-resources.sh -s nfsdisk`

TBD - Properly map ports for each respective service.

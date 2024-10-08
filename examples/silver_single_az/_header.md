# Single-AZ deployment (Silver)

This example deploys an Oracle exadata appliance, with a virtual network to support it.  All resources are deployed in a single Availability zone, with no redundancy.

It deploys the following resources

- A Log Analytics workspace for collecting logs/metrics from vnet
- A Virtual network for hosting the Exadata cluster
- An Oracle Cloud Infrastructure resource - with a default configuration
- An Oracle VM Cluster to be deployed on the Oracle Cloud Infrastructure resource

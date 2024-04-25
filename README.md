# ocean-controller-upgrade
The following script was put together to help Ocean customers upgrade their Ocean controllers to version 2.0. Once your kube-context is set to the cluster you would like to upgrade, running this script will export the necessary token, Spot account and cluster identifier, scale your existing Ocean cluster to Zero replicas and then install the new controller using the script provided. 

Note:

If the Ocean Prometheus Exporter or Ocean Network Client is already installed in your cluster, reinstall them by setting ENABLE_OCEAN_METRIC_EXPORTER or ENABLE_OCEAN_NETWORK_CLIENT to 'true' for the integration with the new controller

(Optional) To enable the Right Sizing feature, set INCLUDE_METRIC_SERVER to true to install the Metric Server.

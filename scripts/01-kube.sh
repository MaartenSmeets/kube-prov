echo Create model
juju add-model k8s
cat << EOF > bundle.yaml
description: A highly-available, production-grade Kubernetes cluster.
series: bionic
applications:
  etcd:
    num_units: 1
  kubernetes-master:
    constraints: cores=2 mem=3G root-disk=16G
    num_units: 2
    options:
       channel: 1.18/stable
  kubernetes-worker:
    constraints: cores=2 mem=3G root-disk=20G
    num_units: 4
    options:
       channel: 1.18/stable
EOF
juju deploy charmed-kubernetes --overlay bundle.yaml --trust
sleep 240
echo Clean VMs
for i in `virsh list --state-shutoff --name`; do virsh undefine $i --remove-all-storage; done
sleep 1200
juju scp kubernetes-master/0:config ~/.kube/config
juju config kubernetes-master enable-dashboard-addons=true

echo Install OpenEBS
#OpenEBS
juju run "sudo systemctl enable iscsid && sudo systemctl start iscsid" --application kubernetes-worker  
juju config kubernetes-master allow-privileged=true  
juju run "reboot" --application kubernetes-master  
sleep 120
juju run "reboot" --application kubernetes-worker
sleep 120
kubectl create namespace openebs 
helm repo add openebs https://openebs.github.io/charts  
helm repo update
helm install openebs stable/openebs --version 1.10.0 --namespace openebs
sleep 240
kubectl patch storageclass openebs-jiva-default -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
echo Install Docker registry
juju deploy ~containers/docker-registry
juju add-relation docker-registry easyrsa:client
juju config docker-registry auth-basic-user='admin' auth-basic-password='admin'
juju add-relation docker-registry containerd  
export IP=`juju run --unit docker-registry/0 'network-get website --ingress-address'`
export PORT=`juju config docker-registry registry-port`
export REGISTRY=$IP:$PORT
juju config containerd custom_registries='[{"url": "https://'$REGISTRY'", "username": "admin", "password": "admin"}]'
echo Install MetalLB
cat << EOF > metallb-config.yaml
configInline:
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 10.20.81.190-10.20.81.253
EOF
helm install metallb -f metallb-config.yaml stable/metallb

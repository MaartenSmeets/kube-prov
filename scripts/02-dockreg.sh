juju deploy ~containers/docker-registry
juju add-relation docker-registry easyrsa:client
juju config docker-registry auth-basic-user='admin' auth-basic-password='admin'
juju add-relation docker-registry containerd  
export IP=`juju run --unit docker-registry/0 'network-get website --ingress-address'`
export PORT=`juju config docker-registry registry-port`
export REGISTRY=$IP:$PORT
juju config containerd custom_registries='[{"url": "https://'$REGISTRY'", "username": "admin", "password": "admin"}]'


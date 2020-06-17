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


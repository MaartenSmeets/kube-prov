helm repo add stable https://kubernetes-charts.storage.googleapis.com
helm repo update
kubectl create namespace jenkins
helm install my-jenkins-release stable/jenkins --namespace jenkins

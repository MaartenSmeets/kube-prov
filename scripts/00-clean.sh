echo `date`
echo Destroy model
juju destroy-model -y k8s
sleep 10
echo Network
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv4.conf.br0.proxy_arp=1
sudo sysctl -w net.ipv4.conf.br0.proxy_arp_pvlan=1
sudo service maas-rackd restart


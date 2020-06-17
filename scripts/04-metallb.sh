cat << EOF > metallb-config.yaml
configInline:
    address-pools:
    - name: default
      protocol: layer2
      addresses:
      - 10.20.81.190-10.20.81.253
EOF
helm install metallb -f metallb-config.yaml stable/metallb


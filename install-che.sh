mkdir ${HOME}/Desktop/install-che

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud-generic.yaml

curl https://raw.githubusercontent.com/eclipse/codewind-che-plugin/master/setup/install_che/che-operator/codewind-checluster.yaml --output ${HOME}/Desktop/install-che/codewind-checluster.yaml

kubectl apply -f https://raw.githubusercontent.com/eclipse/codewind-che-plugin/master/setup/install_che/codewind-clusterrole.yaml

kubectl apply -f https://raw.githubusercontent.com/eclipse/codewind-che-plugin/master/setup/install_che/codewind-rolebinding.yaml

export CHE_DOMAIN=$(kubectl get services --namespace ingress-nginx -o jsonpath='{.items[*].spec.clusterIP}')

echo "Enter your sudo password at next prompt"
sudo ifconfig lo0 alias ${CHE_DOMAIN}

sed "s/ingressDomain: ''/ingressDomain: '${CHE_DOMAIN}.nip.io'/g" ${HOME}/Desktop/install-che/codewind-checluster.yaml >${HOME}/Desktop/install-che/codewind-checluster.modified.yaml

chectl server:start --platform=k8s --installer=operator --domain=${CHE_DOMAIN}.nip.io --che-operator-cr-yaml=${HOME}/Desktop/install-che/codewind-checluster.modified.yaml

echo "Open a Chrome browser window and install Codewind with username: admin,  password: admin"

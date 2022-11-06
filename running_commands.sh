# Important points about bootstrapping a cluster
# 1) Dont forget to run the command to update lsmod in each nodes. That should be first command you run
# 2) after updating containerd config don't forget to restart 
# 3) don't forget to add keys for kubernetes. if specific version needs to installed add it in sudo command
# 4) add nodes first before installing a cni plugin. have tried with calico confirm if 


# bootstrapping a cluster from scratch
ec2-instance ec2-54-164-58-70.compute-1.amazonaws.com

#1 conifgure container runtime containerd
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system


# Create user and contexts


#Creae roles
k create role read-only --verb=list,get,watch --resources=pod,deployments,services

k describe role read-only

k create rolebinding read-only-binding --role=read-only --user=rixon-doe
   
# bootstrapping a cluster
# log into the control plane and run the below commands

sudo kubeadm init --pod-network-cidr 172.18.0.0/16 --apiserver-advertise-address 10.8.8.10

# deploy a cni plugin

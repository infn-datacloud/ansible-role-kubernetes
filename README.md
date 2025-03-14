# Kubernetes Role

This ansible role customizes a [Kubernetes](https://kubernetes.io/) cluster.

## Role Variables

The variables that can be passed to this role and a brief description about them are as follows:

    # Type of node front or wn
    kube_type_of_node: front
    # Flag to set HELM to be installed
    kube_install_helm: true
    # If true, running kubernetes etcd in ramdisk
    etcd_in_RAM: true
    # Deploy the Dashboard
    kube_deploy_dashboard: true
    # Flag to enable GPU support
    enable_gpu: false
    # Name (and version) of the Ansible role to include if `enable_gpu == true'
    gpu_support_role: git+https://baltig.infn.it/infn-cloud/ansible-role-gpu-support,vX.Y.Z

## Dependencies

- ansible-role-gpu-support (if `enable_gpu == true`)
- ansible-role-cron

## ETCD in RAM

### Requirements

The cluster must be using containerd as the container runtime and etcd must be running as a pod in the kubernetes cluster.

### Manual setup for an existing cluster

First, download nerdctl from [here](https://github.com/containerd/nerdctl) and move the executable to `/usr/local/bin`. Then, copy the contents of the `files_etcdRAM` folder as follows:

```text
files_etcdRAM/usr/lib/systemd/system/kubelet.service.d ---> /usr/lib/systemd/system/kubelet.service.d
files_etcdRAM/etc/cron.d ---> /etc/cron.d
files_etcdRAM/opt/etcdRAM/bin ---> /opt/etcdRAM/bin
```

Restart `daemon` and update `crontab`:

```bash
systemctl daemon-reload
crontab /etc/cron.d/etcdRAM-etcd
```

To mount the storage directory `/var/lib/etcd` as a ramdisk requires adding a single line to `/etc/fstab`:

```text
tmpfs                       /var/lib/etcd        tmpfs   defaults,noatime,size=2g  0 0
```

Finally remove all contents from the `/var/lib/etcd` directory and mount the ramdisk:

```bash
rm -rf /var/lib/etcd/*
mount -a
```

### Credits

See also the [post](https://brakkee.org/site/2023/02/14/silencing-kubernetes-at-home/) and the [original repository](https://git.wamblee.org/blog/code/src/branch/main/etcd-inmemory), where this was described.

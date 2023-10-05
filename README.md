# homelab

This repository contains my homelab orchestration and notes.

## Inspiration

* onedr0p home-ops

## Setup

1. Setup fedora coreos on k8s hosts
2. Setup k3s as the kubernetes cluster
3. Setup flux to manage apps
4. Configure Renovate

## Configuring Renovate

1. Go to <https://github.com/apps/renovate> and click "Install"
2. Follow the steps to "Install" "Renovate" in all appropriate repositories.
3. Agree to Mend policies to have an account
4. Start Setup Wizard
5. Use Interactive Mode
6. Run renovate on appropriate repository

## Configuration Notes

* using csi-driver-nfs for PVCs backed by NFS. This was chosen instead of the [nfs-subdir-external-provisioner](https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner)
  because one says it is a csi-driver.

## Fedora Core OS Installation

I used the following command to generate the ignition configuration:

```shell
ansible-playbook -i inventory.yml --vault-id inventory@.vault-pass \
  playbooks/ignite.yml \
  -e ignition_dest='{{ ignition_hostname }}.ign' \
  -e ignition_disk=/dev/sda \
  -e arch=aarch64 \
  -e pubkey=ssh.pub
```

## Flux notes

`flux reconcile source git home-kubernetes` immediately pulls git changes

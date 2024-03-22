# Ansible-Deploy-Docker
Simple ansible playbook to deploy latest docker and docker-compose via ansible.

## Edit configs

### add_ansible_user.sh

__<ANSIBLE_USERNAME>__ -- Set a username for ansible. Example "ansible"

__<YOUR_PUBKEY>__ -- Paste your public key.

__UID_INT__ -- This is optional. By default it is set to 1600. It makes it easier to distinguish ansible user from the rest 

### DockerEngineInstall.yml

The only thing to change here is __<CHANGE_HOSTS>__ at line 3. There you need to input IP of computers that ansible will run this playbook on.

## PS

In Proxmox if you have a VM template it is possible to paste multiple pubkeys. Go to template -> Cloud-Init -> SSH public key -> edit -> paste your pubkeys.

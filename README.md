## Description

Ansible playbook to customize my Debian 12 XFCE desktop.

**_Use it at your own risk. Not open for pull requests or issues._**

```
./wrapper-script.sh

# or install ansible requirements and run
ansible-playbook playbook/setup-workstation.yml --diff --ask-become-pass

# to run a specific tag (may need to set first time install)
ansible-playbook playbook/setup-workstation.yml --diff --ask-become-pass -t <tag>
```

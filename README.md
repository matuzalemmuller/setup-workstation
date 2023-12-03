## Description

Ansible playbook to customize my Debian 12 XFCE desktop.

Everything should be not user-specific, except for [playbook/config/tasks/configure-git.yml](/playbook/config/tasks/configure-git.yml).

**_Use it at your own risk. Not open for pull requests or issues._**

```
./wrapper-script.sh
# or install requirements and run
ansible-playbook playbook/setup-workstation --ask-become-pass
```

#!/bin/bash

DIR=$(dirname $0)
ROLES_DIR="${DIR}/roles"
PLAYBOOK_FILE="localhost.yml"

update_role() {
  echo "Update role ${1}"
  test -d ${ROLES_DIR}/${1} && pushd . &>/dev/null && cd ${ROLES_DIR}/${1} && git pull && popd &>/dev/null || git clone ${2} ${ROLES_DIR}/${1}
}

check_package() {
    dpkg -l ${1} &>/dev/null && echo "${1} found" || ! echo -e "     ${1} not installed.\nInstalling ${1} requires root privileges" || sudo apt install -y ${1}
}

install_ansible() {
    sudo apt-get -y update
    sudo apt-get -y install software-properties-common
    sudo apt-add-repository -y ppa:ansible/ansible
    sudo apt-get -y update
    sudo apt-get -y install ansible
}

echo "=== Check required packages ==="
check_package git
check_package python-minimal
dpkg -l ansible &>/dev/null || install_ansible
echo

ROLES=$(python parser.py)

echo "=== Update roles ==="
while read name url; do
    update_role ${name} ${url}
done <<<"${ROLES}"
echo

echo "=== Generate playbook ==="
cat <<EOT >${PLAYBOOK_FILE}
---
- hosts: localhost
  roles:
EOT
while read name url; do
    echo "    - ${name}" >>${PLAYBOOK_FILE}
done <<<"${ROLES}"
echo

echo "=== Run playbook ==="
ansible-playbook ${PLAYBOOK_FILE}

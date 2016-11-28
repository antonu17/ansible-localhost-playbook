#!/bin/bash

GIT_PREFIX_URL="https://github.com/antonu17"
DIR=$(dirname $0)
ROLES_DIR="${DIR}/roles"

update_role() {
  echo "Update role ${1}"
  test -d ${ROLES_DIR}/${1} && pushd .; cd ${ROLES_DIR}/${1}; git pull; popd || git clone ${GIT_PREFIX_URL}/${2}.git ${ROLES_DIR}/${1}
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
dpgk -l ansible &>/dev/null || install_ansible
echo


echo "=== Update roles ==="
update_role xenial-java ansible-java-role
update_role xenial-openstack-clients ansible-openstack-clients
update_role xenial-docker ansible-docker-role
update_role xenial-virtualbox ansible-virtualbox-role
update_role xenial-virtualization ansible-virtualization-role
echo

echo "=== Run playbook ==="
ansible-playbook localhost.yml

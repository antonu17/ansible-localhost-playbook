#!/bin/bash

GIT_PREFIX_URL="https://github.com/antonu17"
DIR=$(dirname $0)
ROLES_DIR="${DIR}/roles"

update_role() 
{
  echo "Update role ${1}"
  test -d ${ROLES_DIR}/${1} && git pull || git clone ${GIT_PREFIX_URL}/${2}.git ${ROLES_DIR}/${1}
}

echo "=== Update roles ==="
update_role xenial-java ansible-java-role
update_role xenial-openstack-clients ansible-openstack-clients
update_role xenial-docker ansible-docker-role
update_role xenial-virtualbox ansible-virtualbox-role
update_role xenial-virtualization ansible-virtualization-role

echo "=== Run playbook ==="
ansible-playbook localhost.yml

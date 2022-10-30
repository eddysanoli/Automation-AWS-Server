FROM python:3.9

# Update the container and install the dependencies
RUN apt-get update && apt-get install -y curl \
    sshpass \
    ansible

# Move back to the default working directory for opus
WORKDIR /opt/ansible

# Copy both the ansible configuration and the inventory file
COPY ./configuration/ansible.cfg /opt/ansible/ansible.cfg
COPY ./configuration/hosts /etc/ansible/hosts

# Run the "provision.yaml" playbook:
# - Using the inventory file "hosts"
# - Using the "root" user
# - Configuring SSH access copying the local machine's private SSH key (id_rsa)
ENTRYPOINT ["ansible-playbook", "-u", "root", "/opt/ansible/playbooks/provision.yaml"]

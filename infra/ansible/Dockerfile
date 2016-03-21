from debian:jessie

ENV DEBIAN_FRONTEND noninteractive

run apt-get update && \
    apt-get install -y ansible ssh && \
    rm -rf /var/lib/apt/lists/*
add ./playbooks /playbooks
add ./ssh /root/.ssh
add ./conf/ansible.cfg /etc/ansible/ansible.cfg
add ./entrypoint.sh /entrypoint.sh
entrypoint ["./entrypoint.sh"]
cmd ["/playbooks/provision.yml"]

FROM almalinux/8-init:8.6

RUN dnf update -y && \
    dnf install -y net-tools openssh-server openssl python39 sudo && \
    dnf autoremove

RUN sed -i "s/.*PubkeyAuthentication.*/PubkeyAuthentication yes/g" /etc/ssh/sshd_config && \
    sed -i "s/.*PasswordAuthentication.*/PasswordAuthentication no/g" /etc/ssh/sshd_config && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    /usr/bin/ssh-keygen -A

RUN useradd -m -s /bin/bash -G wheel -p $(openssl passwd -1 eee) ssluser
COPY --chown=ssluser:ssluser ./ssh_key.pub /home/ssluser/.ssh/authorized_keys

CMD ["/usr/sbin/sshd", "-D"]

EXPOSE 22

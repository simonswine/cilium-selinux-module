FROM centos:8

RUN dnf -y install policycoreutils-python-utils checkpolicy && \
    dnf clean all && \
    rm -rf /var/cache/yum

ADD entrypoint.sh /

CMD /entrypoint.sh

FROM ubuntu:23.04

RUN sed -i \
    -e 's|http://archive.ubuntu.com/ubuntu|http://old-releases.ubuntu.com/ubuntu|g' \
    -e 's|http://security.ubuntu.com/ubuntu|http://old-releases.ubuntu.com/ubuntu|g' \
    /etc/apt/sources.list && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        xinetd \
        libpixman-1-dev \
        libepoxy-dev \
        libspice-server-dev \
        libfdt-dev \
        libusb-1.0.0-dev \
        libasound-dev \
        libaio-dev \
        libslirp-dev \
        gdb \
        python3 \
        file \
        binutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -m user

COPY share/flag /home/user/flag
COPY share/qemu-system-x86_64 /home/user/qemu-system-x86_64
COPY share/bios /home/user/bios
COPY share/run.sh /home/user/run.sh
COPY share/bzImage /home/user/bzImage
COPY share/initramfs.cpio.gz /home/user/initramfs.cpio.gz
COPY xinetd /etc/xinetd.d/maria

RUN chmod +x /home/user/qemu-system-x86_64 /home/user/run.sh && \
    chown -R user:user /home/user

USER user
WORKDIR /home/user

CMD ["/usr/sbin/xinetd", "-dontfork"]

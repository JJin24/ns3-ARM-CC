FROM ubuntu:18.04
LABEL maintainer="JJin24 <lijinting32@gmail.com>"

# 使用台灣的 Ubuntu 軟體源 (TWDS)
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|http://tw.archive.ubuntu.com/ubuntu/|g' \
/etc/apt/sources.list

# 更新 apt 套件清單
RUN apt update

# 安裝編譯工具
RUN apt install g++-8-arm-linux-gnueabi gcc-8-arm-linux-gnueabi bison flex libnl-3-dev \
libnl-genl-3-dev make pkg-config g++ python3 cmake ninja-build git ccache -y

RUN update-alternatives --install /usr/bin/arm-linux-gnueabi-g++ arm-linux-gnueabi-g++ \
/usr/bin/arm-linux-gnueabi-g++-8 10

RUN update-alternatives --install /usr/bin/arm-linux-gnueabi-gcc arm-linux-gnueabi-gcc \
/usr/bin/arm-linux-gnueabi-gcc-8 10

# 額外工具
RUN apt install ssh curl net-tools iproute2 htop iputils-ping tmux vim nano -y

# 編譯 libnl ARM 版本
RUN cd /tmp \
    && curl -fsSLO https://www.infradead.org/~tgr/libnl/files/libnl-3.2.24.tar.gz \
    && tar -xzf libnl-3.2.24.tar.gz \
    && cd libnl-3.2.24 \
    && ./configure ARCH=arm CC=/usr/bin/arm-linux-gnueabi-gcc --host=arm-linux \
        --enable-shared --enable-static \
    && make \
    && make install \
    && rm -rf /tmp/libnl-3.2.24 /tmp/libnl-3.2.24.tar.gz

CMD ["tail", "-f", "/dev/null"]

FROM osrf/ros:noetic-desktop-full

LABEL org.opencontainers.image.authors="zhaolingzhe@westlake.edu.cn"

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai LANG=C.UTF-8 LC_ALL=C.UTF-8 PIP_NO_CACHE_DIR=1 PIP_CACHE_DIR=/tmp/

RUN sed -i "s/archive.ubuntu.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list &&\
    sed -i "s/security.ubuntu.com/mirrors.ustc.edu.cn/g" /etc/apt/sources.list &&\
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ros/ubuntu/ focal main /" > \
        /etc/apt/sources.list.d/ros1-snapshots.list &&\
    apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 &&\
    apt-get update && apt-get upgrade -y &&\
    apt-get install -y --no-install-recommends \
        # Common
        autoconf automake autotools-dev build-essential ca-certificates \
        make cmake ninja-build pkg-config g++ ccache yasm \
        ccache doxygen graphviz plantuml \
        daemontools krb5-user ibverbs-providers libibverbs1 \
        libkrb5-dev librdmacm1 libssl-dev libtool \
        libnuma1 libnuma-dev libpmi2-0-dev \
        openssh-server openssh-client nfs-common \
        ## Tools
        git curl wget unzip nano vim-tiny net-tools sudo htop iotop iputils-ping \
        cloc rsync screen tmux xz-utils software-properties-common \
        ## Deps
        ros-noetic-sophus \
        ros-noetic-pcl-ros \
        ros-noetic-eigen-conversions \
        ros-noetic-camera-info-manager \
        ros-noetic-image-view \
        ros-noetic-camera-info-manager \
        ros-noetic-image-geometry \
        libfftw3-dev libfftw3-doc \
        libglew-dev \
        libopencv-dev \
        libyaml-cpp-dev \
        python3-catkin-tools \
        python3-rosdep \
        python3-vcstool \
    && rm /etc/ssh/ssh_host_ecdsa_key \
    && rm /etc/ssh/ssh_host_ed25519_key \
    && rm /etc/ssh/ssh_host_rsa_key \
    && cp /etc/ssh/sshd_config /etc/ssh/sshd_config_bak \
    && sed -i "s/^.*X11Forwarding.*$/X11Forwarding yes/" /etc/ssh/sshd_config \
    && sed -i "s/^.*X11UseLocalhost.*$/X11UseLocalhost no/" /etc/ssh/sshd_config \
    && grep "^X11UseLocalhost" /etc/ssh/sshd_config || echo "X11UseLocalhost no" >> /etc/ssh/sshd_config \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN git clone --recursive https://gitlab.com/inivation/dv/libcaer &&\
    cd libcaer &&\
    mkdir build &&\
    cd build &&\
    cmake .. &&\
    make -j &&\
    make install &&\
    cd /tmp &&\
    rm -rf libcaer

RUN mkdir -p /workspace/src &&\
    cd /workspace/src &&\
    git clone --branch noetic https://github.com/LingzheZhao/rpg_dvs_evo_open &&\
    vcs-import < rpg_dvs_evo_open/dependencies.yaml &&\
    cd /workspace &&\
    catkin config \
            --init --mkdirs --extend /opt/ros/noetic \
            --merge-devel --cmake-args \
            -DCMAKE_BUILD_TYPE=Release \
            &&\
    catkin build

RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc &&\
    echo "source /workspace/devel/setup.bash" >> /root/.bashrc &&\
    ln -s /usr/bin/python3 /usr/bin/python

WORKDIR /workspace

CMD ["/bin/bash"]

# #!/bin/bash

echo "First, we install the required apt packages"
sudo apt-get update
sudo apt-get install -y software-properties-common git nano vim wget curl
# sudo add-apt-repository -y ppa:inivation-ppa/inivation-bionic
# sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
sudo apt-get install -y         \
    ros-$1-sophus               \
    ros-$1-pcl-ros              \
    ros-$1-eigen-conversions    \
    ros-$1-camera-info-manager  \
    ros-$1-image-view           \
    libfftw3-dev libfftw3-doc   \
    libglew-dev                 \
    libopencv-dev               \
    libyaml-cpp-dev             \
    libtool                     \
    python3-rosdep              \
    python3-catkin-tools        \
    python3-vcstool             \
    ros-$1-camera-info-manager  \
    ros-$1-image-geometry

# python-vcstool              \
# python-rosdep               \
# gcc-10 g++-10               \
# libcaer-dev                 \

git clone --recursive https://gitlab.com/inivation/dv/libcaer
cd libcaer
mkdir build
cd build
cmake ..
make -j
sudo make install
cd ../../

echo "Second, we clone the evo dependencies"
vcs-import < rpg_dvs_evo_open/dependencies.yaml

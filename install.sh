# #!/bin/bash

echo "First, we install the required apt packages"

# Note: this ppa contains OpenCV 4 that may break ROS melodic, so don't use it
# sudo add-apt-repository ppa:inivation-ppa/inivation-bionic

sudo apt-get update
sudo apt-get install \
    ros-melodic-sophus \
    ros-melodic-pcl-ros \
    ros-melodic-eigen-conversions \
    ros-melodic-camera-info-manager \
    ros-melodic-image-view \
    ros-melodic-camera-info-manager \
    ros-melodic-image-geometry \
    libfftw3-dev libfftw3-doc \
    libglew-dev \
    libopencv-dev \
    libyaml-cpp-dev \
    python-catkin-tools \
    python-rosdep \
    python-vcstool

# Build libcaer
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

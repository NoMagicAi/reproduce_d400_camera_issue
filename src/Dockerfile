from ros:kinetic-ros-base

# Copyright 2019 NoMagic Sp. z o.o.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Setup working and source directories
RUN mkdir -p /code/src
WORKDIR /code


# Install Intel(R) RealSense(TM) SDK (https://github.com/IntelRealSense/librealsense/tree/v2.16.1)
RUN apt-get update && apt-get install -y \
    git \
    libssl-dev \
    libusb-1.0-0-dev \
    pkg-config \
    libgtk-3-dev \
    libglfw3-dev \
    udev

ENV LIBREALSENSE_VERSION 'v2.16.1'

RUN git clone --branch ${LIBREALSENSE_VERSION} https://github.com/IntelRealSense/librealsense.git

RUN mkdir -p librealsense/build && \
    cd librealsense/build && \
    cmake ../ && \
    make uninstall && make clean && make && make install


# Install Intel(R) RealSense(TM) ROS wrapper for D400 camera (https://github.com/IntelRealSense/realsense-ros/tree/2.1.0)
RUN apt-get install -y \
    ros-kinetic-rgbd-launch \
    ros-kinetic-image-transport-plugins \
    ros-kinetic-image-transport \
    ros-kinetic-tf \
    ros-kinetic-diagnostic-updater

ENV LIBREALSENSE_ROS_VERSION '2.1.0'

RUN cd src && \
    git clone --branch ${LIBREALSENSE_ROS_VERSION} https://github.com/IntelRealSense/realsense-ros.git

RUN /bin/bash -c \
    "source /opt/ros/kinetic/setup.bash && \
    cd src && \
    catkin_init_workspace && \
    cd ../ && \
    catkin_make -DCATKIN_ENABLE_TESTING=False -DCMAKE_BUILD_TYPE=Release && \
    catkin_make install && \
    echo 'source /code/devel/setup.bash' >> /root/.bashrc"

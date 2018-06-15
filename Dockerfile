FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
#FROM ubuntu:16.04
MAINTAINER Fabio Magalhaes<fabio.magalhaes@gmail.com>

ENV PYTHONPATH /opt/movidius/mvnc/python:${PYTHONPATH}
ARG TF_VERSION

RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y python-pip
RUN apt-get install -y wget
RUN apt-get install -y sudo
RUN apt-get install -y nano
RUN apt-get install -y lsb-release
RUN apt-get install -y python3-pip

RUN git clone https://github.com/movidius/ncsdk.git /ncsdk
RUN git clone https://github.com/movidius/ncappzoo.git /ncappzoo

RUN pip install --upgrade pip
#RUN pip install tensorflow-gpu==1.4.1
RUN pip3 install --upgrade pip
#RUN pip3 install opencv-python
#RUN pip3 install opencv-contrib-python

#Install OpenCV from source
#WORKDIR ${HOME}
#COPY ./scripts/install-opencv-from_source.sh ${HOME}
#RUN ${HOME}/install-opencv-from_source.sh


WORKDIR /ncsdk
RUN make install
#RUN make examples

# Go to NCSDK root
#WORKDIR /
#RUN git clone https://github.com/tensorflow/tensorflow.git tf-${TF_VERSION}
#RUN git clone https://github.com/tensorflow/models.git tf-models
#RUN cd tf-${TF_VERSION} && git checkout ${TF_VERSION} && cd ..
#ENV TF_SRC_PATH=/tf-${TF_VERSION}
#ENV TF_MODELS_PATH=/tf-models

# we only check with tensorflow example
#WORKDIR /ncappzoo/tensorflow
WORKDIR /ncappzoo/apps
#RUN make

# ROS Kinetic
WORKDIR ${HOME}
RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116 \
    && sh -c 'echo "deb http://packages.ros.org/ros/ubuntu xenial main" > /etc/apt/sources.list.d/ros-latest.list' \
    && sh -c 'echo "deb http://packages.ros.org/ros-shadow-fixed/ubuntu/ xenial main" > /etc/apt/sources.list.d/ros-shadow.list' \
    && apt-get update && apt-get -y --no-install-recommends install \
        ros-kinetic-gazebo-ros-pkgs             \
        ros-kinetic-mavros                      \
        ros-kinetic-mavros-extras               \
        ros-kinetic-ros-base                    \
        ros-kinetic-joy                         \
        ros-kinetic-rviz                        \
        ros-kinetic-image-view                  \
        ros-kinetic-rqt-image-view              \
        ros-kinetic-image-transport-plugins     \
        ros-kinetic-usb-cam                     \
        ros-kinetic-video-stream-opencv         \
        ros-kinetic-rqt                         \
        ros-kinetic-rqt-common-plugins          \
        ros-kinetic-rqt-robot-plugins           \
        ros-kinetic-camera-info-manager         \
        ros-kinetic-camera-calibration-parsers  \
        ros-kinetic-image-transport             \
        ros-kinetic-roslint                     \
    && apt-get -y autoremove        \
    && apt-get clean autoclean      \
    && rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

# Initialize ROS
RUN geographiclib-get-geoids egm96-5 \
    && rosdep init                   \
    && rosdep update

RUN echo 'source /opt/ros/kinetic/setup.bash' >> ${HOME}/.bashrc

RUN apt-get install -y python-catkin-tools

# To be run by a user after creating a container.
COPY ./scripts/build_movidius.sh ${HOME}

# Setup catkin workspace
ENV CATKIN_WS ${HOME}/catkin_ws
COPY ./scripts/init_workspace.sh ${HOME}
RUN ${HOME}/init_workspace.sh

ENV CCACHE_CPP2=1
ENV CCACHE_MAXSIZE=1G
ENV DISPLAY :0
#ENV PATH "/usr/lib/ccache:$PATH"
ENV TERM=xterm
# Some QT-Apps/Gazebo don't not show controls without this
ENV QT_X11_NO_MITSHM 1

CMD ["bash"]
